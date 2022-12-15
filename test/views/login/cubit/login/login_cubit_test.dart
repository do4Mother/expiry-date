import 'package:bloc_test/bloc_test.dart';
import 'package:expiry/models/profile.dart';
import 'package:expiry/utils/state_helper.dart';
import 'package:expiry/views/login/cubit/login/login_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helper/models.dart';
import '../../../../helper/repositories.dart';

void main() {
  late MockProfileRepository profileRepository;
  late MockGoogleSignIn mockGoogleSignIn;
  late LoginCubit loginCubit;

  setUp(() {
    mockGoogleSignIn = MockGoogleSignIn();
    profileRepository = MockProfileRepository();
    loginCubit = LoginCubit(profileRepository: profileRepository);
    registerFallbackValue(FakeProfile());
  });

  group('emit login', () {
    blocTest(
      'return correct value',
      build: () => loginCubit,
      act: (bloc) => bloc.login('example@example.com', '123'),
      setUp: () {
        final auth = MockFirebaseAuth();
        when(() => profileRepository.signInEmailandPassword(any(), any()))
            .thenAnswer((_) => auth.signInWithEmailAndPassword(email: 'example@example.com', password: '123'));
        when(() => profileRepository.getMyProfile()).thenAnswer((_) async => const Profile(id: '123', email: 'example@example.com'));
      },
      expect: () => [
        isA<StateHelper<Profile>>().having((p0) => p0.status, 'status', Status.loaded).having((p0) => p0.data?.email, 'email', 'example@example.com')
      ],
      verify: (_) {
        verify(() => profileRepository.signInEmailandPassword(any(), any())).called(1);
        verify(() => profileRepository.getMyProfile()).called(1);
      },
    );

    blocTest(
      'return Firebase Exception',
      build: () => loginCubit,
      act: (bloc) => bloc.login('example@example.com', '123'),
      setUp: () {
        final auth = MockFirebaseAuth(
            authExceptions: AuthExceptions(signInWithEmailAndPassword: FirebaseAuthException(code: 'invalid-email', message: 'invalid email')));
        when(() => profileRepository.signInEmailandPassword(any(), any()))
            .thenAnswer((_) => auth.signInWithEmailAndPassword(email: 'example@example.com', password: '123'));
      },
      expect: () => [
        isA<StateHelper<Profile>>().having((p0) => p0.status, 'status', Status.error).having((p0) => p0.message, 'message', 'invalid email'),
      ],
      verify: (_) {
        verify(() => profileRepository.signInEmailandPassword(any(), any())).called(1);
        verifyNever(() => profileRepository.getMyProfile()).called(0);
      },
    );

    blocTest(
      'return Exception',
      build: () => loginCubit,
      act: (bloc) => bloc.login('example@example.com', '123'),
      setUp: () {
        final auth = MockFirebaseAuth();
        when(() => profileRepository.signInEmailandPassword(any(), any()))
            .thenAnswer((_) => auth.signInWithEmailAndPassword(email: 'example@example.com', password: '123'));
        when(() => profileRepository.getMyProfile()).thenThrow(Exception('failed to get profile'));
      },
      expect: () => [
        isA<StateHelper<Profile>>()
            .having((p0) => p0.status, 'status', Status.error)
            .having((p0) => p0.message, 'message', 'Exception: failed to get profile'),
      ],
      verify: (_) {
        verify(() => profileRepository.signInEmailandPassword(any(), any())).called(1);
        verify(() => profileRepository.getMyProfile()).called(1);
      },
    );
  });
}
