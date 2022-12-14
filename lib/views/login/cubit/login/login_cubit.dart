import 'package:expiry/models/profile.dart';
import 'package:expiry/repositories/profile_repository.dart';
import 'package:expiry/utils/state_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<StateHelper<Profile>> {
  final ProfileRepository _profileRepository;

  LoginCubit({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository,
        super(const StateHelper());

  login(String email, String password) async {
    try {
      await _profileRepository.signInEmailandPassword(email, password);
      final profile = await _profileRepository.getMyProfile();

      emit(state.copyWith(status: Status.loaded, data: profile));
    } on FirebaseException catch (e) {
      emit(state.copyWith(status: Status.error, message: e.message ?? ''));
    } catch (e) {
      emit(state.copyWith(status: Status.error, message: e.toString()));
    }
  }

  signInGoogle() async {
    try {
      final user = _profileRepository.getUserAccount();
      final googleCredential = await _profileRepository.signInGoogle();
      if (googleCredential != null) {
        final requestAuth = await googleCredential.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: requestAuth.accessToken,
          idToken: requestAuth.idToken,
        );
        final checkAccount = await _profileRepository.checkAccount(googleCredential.email);
        bool accountIsExist = checkAccount.isNotEmpty;
        Profile? profile;

        if (user != null && user.isAnonymous && !accountIsExist) {
          user.linkWithCredential(credential);
          profile = await _profileRepository.getMyProfile();
          profile = profile?.copyWith(
            id: user.uid,
            createdAt: user.metadata.creationTime ?? DateTime.now(),
            isAnonymous: false,
          );

          if (profile != null) await _profileRepository.updateProfile(profile);
        } else {
          await _profileRepository.signInWithCredential(credential);
          profile = await _profileRepository.getMyProfile();
        }

        emit(state.copyWith(status: Status.loaded, data: profile));
      } else {
        emit(state.copyWith(status: Status.error, message: 'Failed login with google'));
      }
    } on FirebaseException catch (e) {
      emit(state.copyWith(status: Status.error, message: e.message ?? ''));
    } catch (e) {
      emit(state.copyWith(status: Status.error, message: e.toString()));
    }
  }
}
