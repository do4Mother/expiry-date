import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expiry/app/bloc/authentication/authentication_bloc.dart';
import 'package:expiry/models/profile.dart';
import 'package:expiry/repositories/profile_repository.dart';
import 'package:expiry/utils/bloc_helper.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/repositories.dart';

void main() {
  late AuthenticationBloc authenticationBloc;
  late ProfileRepository profileRepository;

  setUp(() {
    profileRepository = MockProfileRepository();
    authenticationBloc = AuthenticationBloc(profileRepository: profileRepository);
  });

  tearDown(() {
    authenticationBloc.close();
  });

  group('AuthenticationBloc Initialize Test', () {
    blocTest(
      'if user already signed in',
      build: () => authenticationBloc,
      setUp: () {
        when(() => profileRepository.isSignedIn()).thenAnswer((_) => true);
        when(() => profileRepository.getMyProfile()).thenAnswer(
          (_) => Future.value(
            const Profile(id: '1234'),
          ),
        );
      },
      act: (bloc) => bloc.add(AuthInitialize()),
      expect: () =>
          [isA<StateHelper>().having((p0) => p0.status, 'status', Status.loaded).having((state) => state.data, 'profile', const Profile(id: '1234'))],
      verify: ((_) {
        verify(() => profileRepository.isSignedIn()).called(1);
        verify(() => profileRepository.getMyProfile()).called(1);
      }),
    );

    blocTest(
      'if user not signed in',
      build: () => authenticationBloc,
      setUp: () {
        when(() => profileRepository.isSignedIn()).thenAnswer((_) => false);
        final user = MockUser(isAnonymous: true, uid: '1234');
        final auth = MockFirebaseAuth(mockUser: user);
        when(() => profileRepository.signInAnonymously()).thenAnswer((_) => auth.signInAnonymously());
      },
      act: (bloc) => bloc.add(AuthInitialize()),
      expect: () => [
        isA<StateHelper>().having(
          (state) => state.data?.id,
          'profile id',
          '1234',
        )
      ],
      verify: ((_) {
        verify(() => profileRepository.isSignedIn()).called(1);
        verify(() => profileRepository.signInAnonymously()).called(1);
      }),
    );

    blocTest(
      'user loggedIn and can\'t get profile',
      build: () => authenticationBloc,
      setUp: () {
        when(() => profileRepository.isSignedIn()).thenAnswer((_) => true);
        when(() => profileRepository.getMyProfile()).thenAnswer(
          (_) => Future.error(FirebaseException(plugin: '', message: 'error')),
        );
      },
      act: (bloc) => bloc.add(AuthInitialize()),
      expect: () => [isA<StateHelper>().having((p0) => p0.status, 'status', Status.error).having((value) => value.message, 'message', 'error')],
      verify: ((_) {
        verify(() => profileRepository.isSignedIn()).called(1);
        verify(() => profileRepository.getMyProfile()).called(1);
      }),
    );
  });
}
