import 'package:flutter/material.dart';
import '../helper/routes/routes.dart';
import '../models/packages_info_model.dart';

class PackageInfoCard extends StatelessWidget {
  final PackageInfoModel package;

  const PackageInfoCard({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Increased elevation for a modern shadow effect
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Package Icon
           
            const SizedBox(width: 16),
            // Package Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package.generalName,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Package: ${package.packageName}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            // Info Button
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: 'More information',
              onPressed: () => _showPackageInfoDialog(context, package),
            ),
            const SizedBox(width: 8),
            // Configure Button
            ElevatedButton(
              onPressed: () {
                 final route = _getRouteForPackage(package.packageName);
    if (route != null) {
      Navigator.pushNamed(context, route);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No screen defined for this package.')),
      );
    }
  
              
              },
              child: const Text('Configure'),
            ),
          ],
        ),
      ),
    );
  }
String? _getRouteForPackage(String packageName) {
  switch (packageName) {
    case 'google_maps_flutter':
      return Routes.googleMapIntegrationRoute;
    case 'firebase_auth':
      return Routes.firebaseAuthRoute;
    // case 'provider':
    //   return Routes.providerRoute;
    default:
      return null;
  }
}

  void _showPackageInfoDialog(BuildContext context, PackageInfoModel package) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(package.generalName),
        content: SingleChildScrollView(
          child: Text(package.infoText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}