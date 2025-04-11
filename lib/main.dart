
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/map_integration_bloc/map_integration_bloc.dart';
import 'helper/routes/routes.dart';
import 'helper/utils.dart/app_theme.dart';
import 'repositories/map_integration_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MapIntegrationBloc(mapIntegrationRepository: MapIntegrationRepository()),
        ),
       
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
      title: 'Automate Integration',
       theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      
      initialRoute: Routes.initialRoute,
      routes: Routes.routesMap,
    ));
  }
}
