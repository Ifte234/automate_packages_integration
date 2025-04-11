
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/map_integration_bloc/map_integration_bloc.dart';
import '../../widgets/primary_btn.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  final TextEditingController _apiKeyController = TextEditingController();
  String? _error;
  bool isPackageAdded = false;
  bool isApiKeySubmitted = false;
  String androidStatus = 'Not configured';
  String iosStatus = 'Not configured';
  String webStatus = 'Not configured';
  String? submittedApiKey;

  void _startIntegration() {
    context.read<MapIntegrationBloc>().add(MapAddPackageEvent());
  }

  void _submitApiKey() {
    final apiKey = _apiKeyController.text.trim();
    context.read<MapIntegrationBloc>().add(MapSubmitApiKeyEvent(apiKey));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Integration Setup'),
        centerTitle: true,
      ),
      body: BlocConsumer<MapIntegrationBloc, MapIntegrationState>(
        listener: (context, state) {
          if (state is MapPackageInstalledSuccessState) {
            setState(() {
              isPackageAdded = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Package added successfully.')),
            );
          } else if (state is MapPackageAlreadyAddedState) {
            setState(() {
              isPackageAdded = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Package already added.')),
            );
          } else if (state is MapApiKeyConfiguredState) {
            // Save API key in the local variable upon successful submission.
            setState(() {
              isApiKeySubmitted = true;
              submittedApiKey = _apiKeyController.text.trim();
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                      Text('API Key applied to your project successfully.')),
            );
          } else if (state is MapAndroidConfiguredState) {
            setState(() {
              androidStatus = 'Configured';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Android configured successfully.')),
            );
          } else if (state is MapAndroidAlreadyConfiguredState) {
            setState(() {
              androidStatus = 'Configured';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Android already configured.')),
            );
          } else if (state is MapIOSConfiguredState) {
            setState(() {
              iosStatus = 'Configured';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('iOS configured successfully.')),
            );
          } else if (state is MapIOSAlreadyConfiguredState) {
            setState(() {
              iosStatus = 'Configured';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('iOS already configured.')),
            );
          } else if (state is MapWebConfiguredState) {
            setState(() {
              webStatus = 'Configured';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Web configured successfully.')),
            );
          } else if (state is MapWebAlreadyConfiguredState) {
            setState(() {
              webStatus = 'Configured';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Web already configured.')),
            );
          } else if (state is MapIntegrationFailureState) {
            setState(() {
              _error = state.error;
            });
          }
        },
        builder: (context, state) {
          final isLoading = state is MapPackageInstallingState;
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProgressIndicator(),
                  const SizedBox(height: 24),
                  if (_error != null) _buildErrorCard(),
                  if (!isPackageAdded) _buildPackageInstallation(isLoading),
                  if (isPackageAdded && !isApiKeySubmitted)
                    _buildApiKeyInput(isLoading),
                  if (isApiKeySubmitted) _buildPlatformConfiguration(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
Widget _buildProgressIndicator() {
  return LinearProgressIndicator(
    value: isApiKeySubmitted
        ? (androidStatus == 'Configured' &&
                   iosStatus == 'Configured' &&
                   webStatus == 'Configured'
              ? 1
              : 0.66)
        : (isPackageAdded ? 0.33 : 0),
    backgroundColor: Colors.grey[200],
    valueColor: AlwaysStoppedAnimation<Color>(
      Theme.of(context).primaryColor,
    ),
  );
}


  Widget _buildErrorCard() {
    return Card(
      color: Colors.red[50],
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageInstallation(bool isLoading) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              leading: Icon(Icons.add_box, size: 32),
              title: Text('Step 1: Add Maps Package'),
              subtitle: Text('Required for basic map functionality'),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: isLoading
                    ? const SizedBox.shrink()
                    : const Icon(Icons.download),
                label: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Install Package'),
                onPressed: isLoading ? null : _startIntegration,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiKeyInput(bool isLoading) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              leading: Icon(Icons.vpn_key, size: 32),
              title: Text('Step 2: API Key Configuration'),
              subtitle: Text('Required for map services'),
            ),
            TextField(
              controller: _apiKeyController,
              decoration: InputDecoration(
                labelText: 'Your Google Maps API Key',
                prefixIcon: const Icon(Icons.security),
                border: const OutlineInputBorder(),
                suffixIcon: isApiKeySubmitted
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
                hintText: 'Paste the key to configure your project...',
              ),
              enabled: !isApiKeySubmitted,
              onChanged: (_) {
                // As soon as the user starts editing, clear the error.
                if (_error != null) {
                  setState(() {
                    _error = null;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                label: const Text('Apply Key to Your Project'),
                onPressed: isLoading ? null : _submitApiKey,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isApiKeySubmitted
                      ? Colors.green
                      : Theme.of(context).primaryColor,
                  // Explicitly set text & icon color to ensure visibility.
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformConfiguration() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              leading: Icon(Icons.settings, size: 32),
              title: Text('Step 3: Platform Configuration'),
              subtitle: Text('Complete setup for both platforms'),
            ),
            _PlatformConfigRow(
              platform: 'Android',
              status: androidStatus,
              icon: Icons.android,
              onConfigure: () {
                if (submittedApiKey != null) {
                  context.read<MapIntegrationBloc>().add(
                        MapConfigureAndroidEvent(submittedApiKey!),
                      );
                }
              },
            ),
            const Divider(),
            _PlatformConfigRow(
              platform: 'iOS',
              status: iosStatus,
              icon: Icons.phone_iphone,
              onConfigure: () {
                if (submittedApiKey != null) {
                  context.read<MapIntegrationBloc>().add(
                        MapConfigureIOSEvent(submittedApiKey!),
                      );
                }
              },
            ),
            const Divider(),
            _PlatformConfigRow(
              platform: 'Web',
              status: webStatus,
              icon: Icons.language,
              onConfigure: () {
                if (submittedApiKey != null) {
                  context.read<MapIntegrationBloc>().add(
                        MapConfigureWebEvent(submittedApiKey!),
                      );
                }
              },
            ),
            if (androidStatus == 'Configured' &&
                iosStatus == 'Configured' &&
                webStatus == 'Configured')
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: const [
                        Icon(Icons.check_circle, color: Colors.green, size: 32),
                        SizedBox(width: 12),
                        Text(
                          'Setup Complete!',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PrimaryBtn(
                      label: 'Configure other packages for your project',
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _PlatformConfigRow extends StatelessWidget {
  final String platform;
  final String status;
  final IconData icon;
  final VoidCallback onConfigure;

  const _PlatformConfigRow({
    required this.platform,
    required this.status,
    required this.icon,
    required this.onConfigure,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  platform,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Status: $status',
                  style: TextStyle(
                    color:
                        status == 'Configured' ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: status == 'Configured' ? null : onConfigure,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  status == 'Configured' ? Colors.grey : Colors.white,
            ),
            child: Text(status == 'Configured' ? 'Completed' : 'Configure'),
          ),
        ],
      ),
    );
  }
}
