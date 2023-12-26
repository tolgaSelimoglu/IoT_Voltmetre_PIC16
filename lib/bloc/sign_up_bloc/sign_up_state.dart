part of 'sign_up_bloc.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();
  
  @override
  List<Object> get props => [];
}

final class SignUpInitial extends SignUpState {}

class SignUpSucceded extends SignUpState{}

class SignUpFailed extends SignUpState{
  final String message;
  SignUpFailed(this.message);

  @override
  List<Object> get props => [message];

}
