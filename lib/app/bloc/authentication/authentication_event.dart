part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthInitialize extends AuthenticationEvent {}

class SignUp extends AuthenticationEvent {
  final Profile profile;
  final String password;

  const SignUp({required this.profile, required this.password});

  @override
  List<Object> get props => [profile, password];
}

class Login extends AuthenticationEvent {
  final String email;
  final String password;

  const Login({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
