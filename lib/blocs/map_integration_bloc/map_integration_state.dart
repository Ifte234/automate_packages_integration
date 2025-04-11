part of 'map_integration_bloc.dart';

abstract class MapIntegrationState extends Equatable {
  const MapIntegrationState();

  @override
  List<Object?> get props => [];
}

class MapIntegrationInitial extends MapIntegrationState {}

class MapProjectPathValidState extends MapIntegrationState {
  final String projectPath;
  const MapProjectPathValidState({required this.projectPath});

  @override
  List<Object?> get props => [projectPath];
}

class MapPackageInstallingState extends MapIntegrationState {}

class MapPackageInstalledSuccessState extends MapIntegrationState {}

class MapApiKeyConfiguredState extends MapIntegrationState {}

class MapPlatformConfiguredState extends MapIntegrationState {}

class MapDemoReadyState extends MapIntegrationState {}

class MapIntegrationFailureState extends MapIntegrationState {
  final String error;
  const MapIntegrationFailureState(this.error);

  @override
  List<Object?> get props => [error];
}

class MapPackageAlreadyAddedState extends MapIntegrationState {}

class MapAndroidConfiguredState extends MapIntegrationState {}

class MapAndroidAlreadyConfiguredState extends MapIntegrationState {}

class MapIOSConfiguredState extends MapIntegrationState {}

class MapIOSAlreadyConfiguredState extends MapIntegrationState {}

class MapWebConfiguredState extends MapIntegrationState {}

class MapWebAlreadyConfiguredState extends MapIntegrationState {}
