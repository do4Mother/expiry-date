import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expiry/models/profile.dart';
import 'package:expiry/repositories/profile_repository.dart';
import 'package:expiry/utils/state_helper.dart';
import 'package:firebase_core/firebase_core.dart';

part 'authentication_event.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, StateHelper<Profile>> {
  final ProfileRepository _profileRepository;

  AuthenticationBloc({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository,
        super(const StateHelper()) {
    on<AuthInitialize>(_authInitialize);
  }

  FutureOr<void> _authInitialize(AuthInitialize event, Emitter<StateHelper> emit) async {
    try {
      Profile? profile;
      if (!_profileRepository.isSignedIn()) {
        final user = await _profileRepository.signInAnonymously();
        profile = Profile(id: user.user?.uid ?? '', createdAt: DateTime.now());
        await _profileRepository.updateProfile(profile);
      } else {
        profile = await _profileRepository.getMyProfile();
      }

      emit(state.copyWith(status: Status.loaded, data: profile));
    } on FirebaseException catch (e) {
      emit(state.copyWith(status: Status.error, message: e.message ?? ''));
    }
  }
}
