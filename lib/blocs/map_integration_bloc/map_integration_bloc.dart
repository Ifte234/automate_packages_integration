import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


import '../../helper/utils.dart/validation.dart';
import '../../repositories/map_integration_repository.dart';

part 'map_integration_event.dart';
part 'map_integration_state.dart';

class MapIntegrationBloc
    extends Bloc<MapIntegrationEvent, MapIntegrationState> {
  final MapIntegrationRepository mapIntegrationRepository;

  MapIntegrationBloc({required this.mapIntegrationRepository})
      : super(MapIntegrationInitial()) {
    on<MapProjectSelectedEvent>(_onProjectSelected);
    on<MapAddPackageEvent>(_onAddPackage);
    on<MapSubmitApiKeyEvent>(_onSubmitApiKey);
    on<MapConfigurePlatformsEvent>(_onConfigurePlatforms);
    on<MapConfigureAndroidEvent>(_onConfigureAndroid);
    on<MapConfigureIOSEvent>(_onConfigureIOS);
    on<MapConfigureWebEvent>(_onMapConfigureWebEvent);
    on<MapDemoIntegrationEvent>(_onDemoIntegration);
  }
  Future<void> _onProjectSelected(
      MapProjectSelectedEvent event, Emitter<MapIntegrationState> emit) async {
    try {
      final isValid =
          await mapIntegrationRepository.validateProject(event.projectPath);
      if (isValid) {
        emit(MapProjectPathValidState(projectPath: event.projectPath));
      } else {
        emit(const MapIntegrationFailureState(
            'Invalid project: pubspec.yaml not found.'));
      }
    } catch (e) {
      emit(MapIntegrationFailureState(e.toString()));
    }
  }

  Future<void> _onAddPackage(
      MapAddPackageEvent event, Emitter<MapIntegrationState> emit) async {
    emit(MapPackageInstallingState());
    try {
      final status = await mapIntegrationRepository.addGoogleMapsDependency();
      if (status == 'added') {
        emit(MapPackageInstalledSuccessState());
      } else if (status == 'already present') {
        emit(MapPackageAlreadyAddedState());
      }
    } catch (e) {
      emit(MapIntegrationFailureState(e.toString()));
    }
  }

  Future<void> _onSubmitApiKey(
      MapSubmitApiKeyEvent event, Emitter<MapIntegrationState> emit) async {
    // Create an instance of Validator.
    final validator = Validation();

    // Validate the API key.
    final validationError = validator.validateMapApiKey(event.apiKey);
    if (validationError != null) {
      // Immediately emit a failure state if validation fails.
      emit(MapIntegrationFailureState(validationError));
      return;
    }

    try {
      // Call repository to configure the API key since validation passed.
      await mapIntegrationRepository.configureApiKey(event.apiKey);
      emit(MapApiKeyConfiguredState());
    } catch (e) {
      // Handle any errors from the repository call.
      emit(MapIntegrationFailureState(e.toString()));
    }
  }

  Future<void> _onConfigureAndroid(
      MapConfigureAndroidEvent event, Emitter<MapIntegrationState> emit) async {
    try {
     
      final status =
          await mapIntegrationRepository.configureAndroid(event.apiKey);
      if (status == 'configured') {
        emit(MapAndroidConfiguredState());
      } else if (status == 'already configured') {
        emit(MapAndroidAlreadyConfiguredState());
      }
    } catch (e) {
      emit(MapIntegrationFailureState(e.toString()));
    }
  }

  Future<void> _onConfigureIOS(
      MapConfigureIOSEvent event, Emitter<MapIntegrationState> emit) async {
    try {
      final status = await mapIntegrationRepository.configureIOS(event.apiKey);
      if (status == 'configured') {
        emit(MapIOSConfiguredState());
      } else if (status == 'already configured') {
        emit(MapIOSAlreadyConfiguredState());
      }
    } catch (e) {
      emit(MapIntegrationFailureState(e.toString()));
    }
  }

  Future<void> _onMapConfigureWebEvent(
      MapConfigureWebEvent event, Emitter<MapIntegrationState> emit) async {
    try {
      final status = await mapIntegrationRepository.configureWeb(event.apiKey);
      if (status == 'configured') {
        emit(MapWebConfiguredState());
      } else if (status == 'already configured') {
        emit(MapWebAlreadyConfiguredState());
      }
    } catch (e) {
      emit(MapIntegrationFailureState(e.toString()));
    }
  }

  Future<void> _onConfigurePlatforms(MapConfigurePlatformsEvent event,
      Emitter<MapIntegrationState> emit) async {
    try {
      await mapIntegrationRepository.configureAndroid(event.apiKey);
      // await mapIntegrationRepository.configureIOS();
      emit(MapPlatformConfiguredState());
    } catch (e) {
      emit(MapIntegrationFailureState(e.toString()));
    }
  }

  Future<void> _onDemoIntegration(
      MapDemoIntegrationEvent event, Emitter<MapIntegrationState> emit) async {
    emit(MapDemoReadyState());
  }
}
