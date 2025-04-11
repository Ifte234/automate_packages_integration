import 'dart:io';
import 'package:path/path.dart' as p;

Future<void> injectGoogleMapWidget(String projectPath) async {
  final libPath = p.join(projectPath, 'lib');
  final configWidgetsPath = p.join(libPath, 'configwidgets');

  if (!await Directory(libPath).exists()) {
    throw Exception('lib directory not found in project at $libPath');
  }

  final configWidgetsDir = Directory(configWidgetsPath);
  if (!await configWidgetsDir.exists()) {
    try {
      await configWidgetsDir.create(recursive: true);
    } catch (e) {
      throw Exception(
          'Failed to create configwidgets directory at $configWidgetsPath: $e');
    }
  }

  final widgetFilePath = p.join(configWidgetsPath, 'map_test_widget.dart');

  // If file exists and contains the widget class, skip writing
  final file = File(widgetFilePath);
  if (await file.exists()) {
    final content = await file.readAsString();
    if (content.contains('class GoogleMapWidget')) {
       return;
    }
  }

  const widgetContent = '''
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatelessWidget {
  const GoogleMapWidget({Key? key}) : super(key: key);

  static const LatLng islamabadLatLng = LatLng(33.6844, 73.0479);

  @override
  Widget build(BuildContext context) {
    final Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('islamabad_marker'),
        position: islamabadLatLng,
        infoWindow: const InfoWindow(
          title: 'Islamabad',
          snippet: 'Capital of Pakistan',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      )
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
        backgroundColor: Colors.teal,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: islamabadLatLng,
              zoom: 14,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: markers,
            mapType: MapType.normal,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: GoogleMapWidget()));
}
''';

  try {
    await file.writeAsString(widgetContent);
    } catch (e) {
    throw Exception(
        'Failed to write map_test_widget.dart at $widgetFilePath: $e');
  }
}
