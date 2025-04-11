import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'integration_event.dart';
part 'integration_state.dart';

class IntegrationBloc extends Bloc<IntegrationEvent, IntegrationState> {
  IntegrationBloc() : super(IntegrationInitial()) {
    on<IntegrationEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
