import 'package:flutter/material.dart';
import '../../screens/firebase_auth_integration/firebase_auth_screen.dart';
import '../../screens/google_maps_integration/google_map_screen.dart';
import '../../screens/common_screens/packages_info_screen.dart';
import '../../screens/common_screens/project_selection_screen.dart';

class Routes {
  static const String initialRoute = '/';
  static const String packageInfoRoute = '/package-info'; 
 // Individual routes per package
  static const String googleMapIntegrationRoute = '/google-map';
  static const String firebaseAuthRoute = '/firebase-auth';



   static final Map<String, WidgetBuilder> routesMap = {
    initialRoute: (context) => const MapProjectSelectionScreen(),
    packageInfoRoute: (context) =>  PackageInfoScreen(),
    googleMapIntegrationRoute: (context) =>  GoogleMapScreen(),
    firebaseAuthRoute: (context) => const FirebaseAuthScreen(),
   
  };
}