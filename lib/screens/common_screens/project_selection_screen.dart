import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';

import '../../blocs/map_integration_bloc/map_integration_bloc.dart';
import '../../helper/routes/routes.dart';

class MapProjectSelectionScreen extends StatefulWidget {
  const MapProjectSelectionScreen({super.key});

  @override
  State<MapProjectSelectionScreen> createState() =>
      _MapProjectSelectionScreenState();
}

class _MapProjectSelectionScreenState extends State<MapProjectSelectionScreen> {
  String? selectedMapProjectPath;
  String? mapIntegrationErrorMessage;

  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<MapIntegrationBloc, MapIntegrationState>(
        listener: (context, state) {
          if (state is MapProjectPathValidState) {
            setState(() {
              selectedMapProjectPath = state.projectPath;
              mapIntegrationErrorMessage = null;
            });
            // Navigate to the integration screen
            Navigator.pushNamed(context, Routes.packageInfoRoute);
          } else if (state is MapIntegrationFailureState) {
            setState(() {
              mapIntegrationErrorMessage = state.error;
            });
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Instruction text
                const Text(
                  ' Select your Flutter project directory',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                // Button to pick directory
                ElevatedButton.icon(
                  onPressed: _pickMapProjectDirectory,
                  icon: const Icon(Icons.folder),
                  label: const Text('Pick Project Directory'),
                ),
                // Display selected directory
                if (selectedMapProjectPath != null) ...[
                  const SizedBox(height: 10),
                  Text('Selected directory: $selectedMapProjectPath'),
                ],
                // Display error message
                if (mapIntegrationErrorMessage != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      mapIntegrationErrorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
                // Divider for separation
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),
                // Supported packages section
                const Text(
                  'Supported Packages for Automatic Configuration:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  children: [
                    const Chip(
                      avatar: Icon(Icons.map),
                      label: Text('Google Maps'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'More packages will be supported soon!',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickMapProjectDirectory() async {
    if (kIsWeb) {
      setState(() {
        mapIntegrationErrorMessage =
            'Directory selection is not supported on the web.';
      });
      return;
    }
    try {
      String? directoryPath = await FilePicker.platform.getDirectoryPath();
      if (directoryPath != null) {
        context
            .read<MapIntegrationBloc>()
            .add(MapProjectSelectedEvent(directoryPath));
      }
    } catch (e) {
      setState(() {
        mapIntegrationErrorMessage = 'Error selecting directory: $e';
      });
    }
  }
}
