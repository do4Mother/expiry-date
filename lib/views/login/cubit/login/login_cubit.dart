import 'package:bloc/bloc.dart';
import 'package:expiry/models/profile.dart';
import 'package:expiry/repositories/profile_repository.dart';
import 'package:expiry/utils/state_helper.dart';
import 'package:firebase_core/firebase_core.dart';

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
}
