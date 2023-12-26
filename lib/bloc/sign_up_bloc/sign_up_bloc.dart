import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picoxiloscope/services/firebase_services.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {

  SignUpBloc() : super(SignUpInitial()) {
    on<SignUp>((event, emit) {
      try {
        FirebaseServices.signUpUser(event.name, event.email, event.password);
        emit(SignUpSucceded());
      } catch (e) {
        emit(SignUpFailed(e.toString()));
      }
    });
  }
}
