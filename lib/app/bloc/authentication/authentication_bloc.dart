import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expiry/models/profile.dart';
import 'package:expiry/repositories/profile_repository.dart';
import 'package:expiry/utils/state_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

part 'authentication_event.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, StateHelper<Profile>> {
  final ProfileRepository _profileRepository;

  AuthenticationBloc({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository,
        super(const StateHelper()) {
    on<AuthInitialize>(_authInitialize);
    on<UpdateProfile>(_updateProfile);
    on<Logout>(_logout);
  }

  FutureOr<void> _authInitialize(AuthInitialize event, Emitter<StateHelper> emit) async {
    try {
      Profile? profile;

      if (!_profileRepository.isSignedIn()) {
        final user = await _profileRepository.signInAnonymously();
        profile = Profile(
          id: user.user?.uid ?? '',
          createdAt: DateTime.now(),
          isAnonymous: true,
        );
        await _profileRepository.updateProfile(profile);
      } else {
        profile = await _profileRepository.getMyProfile();
      }

      emit(state.copyWith(status: Status.loaded, data: profile));
    } on FirebaseException catch (e) {
      emit(state.copyWith(status: Status.error, message: e.message ?? ''));
    } catch (e) {
      emit(state.copyWith(status: Status.error, message: e.toString()));
    }
  }

  FutureOr<void> _updateProfile(UpdateProfile event, Emitter<StateHelper<Profile>> emit) {
    state.copyWith(data: event.profile);
  }

  FutureOr<void> _logout(Logout event, Emitter<StateHelper<Profile>> emit) async {
    await _profileRepository.logout();
    add(AuthInitialize());
  }
}
