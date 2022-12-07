part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  final Profile? profile;

  const AuthenticationState({this.profile});

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoaded extends AuthenticationState {
  const AuthenticationLoaded({
    Profile? profile,
  }) : super(profile: profile);
}

class AuthenticationError extends AuthenticationState {
  final String message;

  const AuthenticationError({required this.message});
}
