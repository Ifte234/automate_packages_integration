import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show File, Platform, Process;

import 'package:path/path.dart' as p;

import '../screens/google_maps_integration/map_test_widget.dart';

class MapIntegrationRepository {
  String? currentProjectPath;
  Future<bool> validateProject(String path) async {
    if (kIsWeb) {
      throw Exception('Unsupported platform: Web is not supported.');
    }
    if (!(Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
      throw Exception(
          'Unsupported platform: Only Windows, macOS, or Linux are supported.');
    }

    final file = File(p.join(path, 'pubspec.yaml'));
    if (await file.exists()) {
      currentProjectPath = path;
      return true;
    }
    return false;
  }

  Future<String> addGoogleMapsDependency() async {
    if (currentProjectPath == null) throw Exception('Project not selected');
    final pubspecFile = File(p.join(currentProjectPath!, 'pubspec.yaml'));
    if (!await pubspecFile.exists()) {
      throw Exception('pubspec.yaml not found');
    }
    final content = await pubspecFile.readAsString();
    if (content.contains('google_maps_flutter:')) {
      return 'already present';
    } else {
      final newContent = content.replaceFirst(
        'dependencies:',
        'dependencies:\n  google_maps_flutter:',
      );
      await pubspecFile.writeAsString(newContent);
      final result = await Process.run('flutter.bat', ['pub', 'get'],
          workingDirectory: currentProjectPath);
      if (result.exitCode != 0) {
        throw Exception('Failed to run flutter pub get: ${result.stderr}');
      }
      return 'added';
    }
  }

  Future<void> configureApiKey(String apiKey) async {
    // No need to store api keys
    return;
  }

  Future<String> configureAndroid(String apiKey) async {
    if (currentProjectPath == null) throw Exception('Project not selected');
    print("configuring android");
    final manifestPath = p.join(
      currentProjectPath!,
      'android',
      'app',
      'src',
      'main',
      'AndroidManifest.xml',
    );

    final manifestFile = File(manifestPath);
    if (!await manifestFile.exists()) {
      throw Exception('AndroidManifest.xml not found');
    }

    var content = await manifestFile.readAsString();

    // ✅ Add missing permissions if not present
    const fineLocationPermission =
        '<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />';
    const coarseLocationPermission =
        '<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />';

    if (!content.contains(fineLocationPermission)) {
      content = content.replaceFirst(
        RegExp(r'<application'),
        '$fineLocationPermission\n$coarseLocationPermission\n\n<application',
      );
    }

    // ✅ Handle Google Maps API key insertion or update
    final metaDataRegex = RegExp(
      r'<meta-data\s+android:name="com\.google\.android\.geo\.API_KEY"\s+android:value="([^"]*)"\s*/?>',
      multiLine: true,
    );

    final existingMeta = metaDataRegex.firstMatch(content);

    if (existingMeta != null) {
      final existingKey = existingMeta.group(1);
      if (existingKey == apiKey) {
        return 'already configured';
      }

      content = content.replaceFirst(
        metaDataRegex,
        '<meta-data android:name="com.google.android.geo.API_KEY" android:value="$apiKey" />',
      );
    } else {
      final applicationTagRegex =
          RegExp(r'(<application[^>]*>)', multiLine: true);
      final appMatch = applicationTagRegex.firstMatch(content);

      if (appMatch != null) {
        final insertMeta =
            '\n        <meta-data android:name="com.google.android.geo.API_KEY" android:value="$apiKey" />';
        content = content.replaceFirst(
            applicationTagRegex, '${appMatch.group(1)}$insertMeta');
      } else {
        throw Exception('<application> tag not found in AndroidManifest.xml');
      }
    }

    await manifestFile.writeAsString(content);

    await injectGoogleMapWidget(currentProjectPath!);
    return 'configured';
  }
Future<String> configureIOS(String apiKey) async {
  if (currentProjectPath == null) throw Exception('Project not selected');
  print("Configuring iOS...");

  final infoPlistPath = p.join(
    currentProjectPath!,
    'ios',
    'Runner',
    'Info.plist',
  );

  final plistFile = File(infoPlistPath);
  if (!await plistFile.exists()) {
    throw Exception('Info.plist not found');
  }

  var content = await plistFile.readAsString();

  const keyTag = '<key>GMSApiKey</key>';
  final valueTag = '<string>$apiKey</string>';

  final existingKeyRegex = RegExp(
    r'<key>GMSApiKey</key>\s*<string>([^<]*)</string>',
    multiLine: true,
  );

  final match = existingKeyRegex.firstMatch(content);

  if (match != null) {
    final existingKey = match.group(1);
    if (existingKey == apiKey) {
      return 'already configured';
    }

    // Replace with new key
    content = content.replaceFirst(
      existingKeyRegex,
      '$keyTag\n  $valueTag',
    );
  } else {
    // Insert new key-value pair before closing </dict>
    if (content.contains('</dict>')) {
      content = content.replaceFirst(
        '</dict>',
        '  $keyTag\n  $valueTag\n</dict>',
      );
    } else {
      throw Exception('</dict> tag not found in Info.plist');
    }
  }

  await plistFile.writeAsString(content);
  await injectGoogleMapWidget(currentProjectPath!);
  return 'configured';
}
Future<String> configureWeb(String apiKey) async {
  if (currentProjectPath == null) throw Exception('Project not selected');
  print("Configuring Web...");

  final indexPath = p.join(
    currentProjectPath!,
    'web',
    'index.html',
  );

  final indexFile = File(indexPath);
  if (!await indexFile.exists()) {
    throw Exception('index.html not found');
  }

  var content = await indexFile.readAsString();

  final scriptTag =
      '<script src="https://maps.googleapis.com/maps/api/js?key=$apiKey"></script>';

  // Check if script already exists with this API key
  if (content.contains(scriptTag)) {
    return 'already configured';
  }

  final scriptRegex = RegExp(
    r'<script\s+src="https:\/\/maps\.googleapis\.com\/maps\/api\/js\?key=([^"]+)"\s*><\/script>',
    multiLine: true,
  );

  // If a script tag already exists with a different key, replace it
  if (scriptRegex.hasMatch(content)) {
    content = content.replaceFirst(
      scriptRegex,
      scriptTag,
    );
  } else {
    // Insert the script before the closing </head> tag
    if (content.contains('</head>')) {
      content = content.replaceFirst(
        '</head>',
        '  $scriptTag\n</head>',
      );
    } else {
      throw Exception('</head> tag not found in index.html');
    }
  }

  await indexFile.writeAsString(content);
  await injectGoogleMapWidget(currentProjectPath!);
  return 'configured';
}

}
