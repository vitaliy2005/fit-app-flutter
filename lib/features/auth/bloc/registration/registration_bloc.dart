import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:contacts_app/repositories/login/login_repository.dart';
import 'package:equatable/equatable.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  
  RegistrationBloc({required this.loginRepository}) : super(RegistrationInitial()) {
    on<RegistrationEventRegistration>((event, emit) async {
      try {
        emit(RegistrationLoading());
        final Map<String, dynamic> data = await loginRepository.registration(event.email, event.surname, event.name, event.password);
        print(data);
        emit(RegistrationSuccess());
      } catch (e) {

      } finally{}
    });
  }
  
  final LoginRepository loginRepository;
}
