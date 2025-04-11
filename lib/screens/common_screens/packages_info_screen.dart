import 'package:flutter/material.dart';

import '../../models/packages_info_model.dart';
import '../../widgets/package_info_card.dart';

class PackageInfoScreen extends StatelessWidget {
  PackageInfoScreen({super.key});

  final List<PackageInfoModel> packages = [
    PackageInfoModel(
      generalName: 'Google Maps',
      packageName: 'google_maps_flutter',
      infoText:
          'The Google Maps package allows you to integrate interactive maps into your Flutter app. '
          'It supports displaying maps, adding markers, drawing polylines, and tracking user location. '
          'You can also customize map styles and handle gestures like zoom and pan.',
    ),
    PackageInfoModel(
      generalName: 'Firebase Authentication',
      packageName: 'firebase_auth',
      infoText:
          'Firebase Authentication provides a secure way to authenticate users in your app. '
          'It supports email/password login, phone authentication, and social logins like Google and Facebook. '
          'It also includes user management features.',
    ),
   
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text('Package Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Packages for Auto-Configuration',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: packages.length,
                itemBuilder: (context, index) =>
                    PackageInfoCard(package: packages[index]),
              ),
            ),
          ],
        ),
      ),
    
    );
  }
}
