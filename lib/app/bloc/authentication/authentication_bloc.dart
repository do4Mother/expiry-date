import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expiry/models/profile.dart';
import 'package:expiry/repositories/profile_repository.dart';
import 'package:firebase_core/firebase_core.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final ProfileRepository _profileRepository;

  AuthenticationBloc({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository,
        super(AuthenticationInitial()) {
    on<AuthInitialize>(_authInitialize);
  }

  FutureOr<void> _authInitialize(AuthInitialize event, Emitter<AuthenticationState> emit) async {
    try {
      if (!_profileRepository.isSignedIn()) {
        final user = await _profileRepository.signInAnonymously();
        final profile = Profile(id: user.user?.uid ?? '', createdAt: DateTime.now());
        await _profileRepository.updateProfile(profile);
      }

      emit(const AuthenticationLoaded());
    } on FirebaseException catch (e) {
      emit(AuthenticationError(message: e.message ?? ''));
    }
  }
}
