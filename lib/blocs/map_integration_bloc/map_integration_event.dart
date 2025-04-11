part of 'map_integration_bloc.dart';
abstract class MapIntegrationEvent extends Equatable {
  const MapIntegrationEvent();

  @override
  List<Object?> get props => [];
}

class MapProjectSelectedEvent extends MapIntegrationEvent {
  final String projectPath;

  const MapProjectSelectedEvent(this.projectPath);

  @override
  List<Object?> get props => [projectPath];
}

class MapAddPackageEvent extends MapIntegrationEvent {}

class MapSubmitApiKeyEvent extends MapIntegrationEvent {
  final String apiKey;

  const MapSubmitApiKeyEvent(this.apiKey);

  @override
  List<Object?> get props => [apiKey];
}

class MapConfigurePlatformsEvent extends MapIntegrationEvent {
  final String apiKey;
   const MapConfigurePlatformsEvent(this.apiKey);

  @override
  List<Object?> get props => [apiKey];
}

class MapDemoIntegrationEvent extends MapIntegrationEvent {}

class MapConfigureAndroidEvent extends MapIntegrationEvent {
  final String apiKey;
  MapConfigureAndroidEvent(this.apiKey);
}

class MapConfigureIOSEvent extends MapIntegrationEvent {
  final String apiKey;
  MapConfigureIOSEvent(this.apiKey);
}
class MapConfigureWebEvent extends MapIntegrationEvent {
  final String apiKey;
  MapConfigureWebEvent(this.apiKey);
}