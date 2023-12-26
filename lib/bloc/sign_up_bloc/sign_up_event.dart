part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUp extends SignUpEvent{
  final String name;
  final String email;
  final String password;

  SignUp({required this.name, required this.email, required this.password});

  @override
  List<Object> get props => [name, email, password];

}