import 'package:expiry/models/profile.dart';
import 'package:expiry/repositories/profile_repository.dart';
import 'package:expiry/utils/state_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpCubit extends Cubit<StateHelper<Profile>> {
  final ProfileRepository _profileRepository;

  SignUpCubit({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository,
        super(const StateHelper());

  signUp(Profile profile, String password) async {
    try {
      final oldUser = _profileRepository.getUserAccount();
      await oldUser?.linkWithCredential(EmailAuthProvider.credential(email: profile.email!, password: password));

      final updatedProfile = profile.copyWith(
        id: oldUser?.uid,
        createdAt: oldUser?.metadata.creationTime ?? DateTime.now(),
        isAnonymous: false,
      );

      await _profileRepository.updateProfile(updatedProfile);

      emit(state.copyWith(status: Status.loaded, data: profile));
    } on FirebaseException catch (e) {
      emit(state.copyWith(status: Status.error, message: e.message ?? ''));
    } catch (e) {
      emit(state.copyWith(status: Status.error, message: e.toString()));
    }
  }
}
