import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'firebase_auth_integration_event.dart';
part 'firebase_auth_integration_state.dart';

class FirebaseAuthIntegrationBloc
    extends Bloc<FirebaseAuthIntegrationEvent, FirebaseAuthIntegrationState> {
  FirebaseAuthIntegrationBloc() : super(IntegrationInitial()) {
    on<FirebaseAuthIntegrationEvent>((event, emit) {});
  }
}
