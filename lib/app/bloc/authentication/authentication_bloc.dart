import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expiry/models/profile.dart';
import 'package:expiry/repositories/profile_repository.dart';
import 'package:expiry/utils/logger.dart';
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
    on<SignUp>(_signUp);
    on<Login>(_login);
  }

  FutureOr<void> _authInitialize(AuthInitialize event, Emitter<StateHelper> emit) async {
    try {
      Profile? profile;
      await _profileRepository.logout();
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

  FutureOr<void> _signUp(SignUp event, Emitter<StateHelper<Profile>> emit) async {
    try {
      final oldUser = _profileRepository.getUserAccount();
      await oldUser?.linkWithCredential(EmailAuthProvider.credential(email: event.profile.email!, password: event.password));

      final profile = event.profile.copyWith(
        id: oldUser?.uid,
        createdAt: oldUser?.metadata.creationTime ?? DateTime.now(),
        isAnonymous: false,
      );

      await _profileRepository.updateProfile(profile);

      emit(state.copyWith(status: Status.loaded, data: profile));
    } on FirebaseException catch (e) {
      emit(state.copyWith(status: Status.error, message: e.message ?? ''));
    } catch (e) {
      emit(state.copyWith(status: Status.error, message: e.toString()));
    }
  }

  FutureOr<void> _login(Login event, Emitter<StateHelper<Profile>> emit) async {
    try {
      await _profileRepository.signInEmailandPassword(event.email, event.password);
      final profile = await _profileRepository.getMyProfile();

      emit(state.copyWith(status: Status.loaded, data: profile));
    } on FirebaseException catch (e) {
      emit(state.copyWith(status: Status.error, message: e.message ?? ''));
    } catch (e) {
      emit(state.copyWith(status: Status.error, message: e.toString()));
    }
  }
}
