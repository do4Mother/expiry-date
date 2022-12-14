part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthInitialize extends AuthenticationEvent {}

class UpdateProfile extends AuthenticationEvent {
  final Profile profile;

  const UpdateProfile({required this.profile});

  @override
  List<Object> get props => [profile];
}
