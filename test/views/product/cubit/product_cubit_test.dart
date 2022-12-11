import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:expiry/models/product.dart';
import 'package:expiry/utils/state_helper.dart';
import 'package:expiry/views/product/cubit/product/product_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helper/models.dart';
import '../../../helper/repositories.dart';

void main() {
  late MockProductRepository productRepository;
  late MockStorageRepository storageRepository;
  late ProductCubit productCubit;

  setUp(() {
    productRepository = MockProductRepository();
    storageRepository = MockStorageRepository();

    productCubit = ProductCubit(
      productRepository: productRepository,
      storageRepository: storageRepository,
    );

    registerFallbackValue(FakeProduct());
    registerFallbackValue(FakeFile());
  });

  group('emit getProduct', () {
    blocTest(
      'with return correct value',
      build: () => productCubit,
      act: (bloc) => bloc.getProduct(''),
      setUp: () {
        final product = Product(id: '123', name: 'testing', expDate: DateTime.now());
        when(() => productRepository.findProduct(any())).thenAnswer((_) => Future.value(product));
      },
      expect: () => [
        isA<StateHelper>().having((p0) => p0.status, 'status', Status.loading),
        isA<StateHelper<Product>>().having((p0) => p0.status, 'status', Status.loaded).having((p0) => p0.data?.id, 'id', '123'),
      ],
    );

    blocTest(
      'with return null value',
      build: () => productCubit,
      act: (bloc) => bloc.getProduct(''),
      setUp: () {
        when(() => productRepository.findProduct(any())).thenAnswer((_) => Future.value(null));
      },
      expect: () => [
        isA<StateHelper>().having((p0) => p0.status, 'status', Status.loading),
        isA<StateHelper<Product>>().having((p0) => p0.status, 'status', Status.loaded).having((p0) => p0.data, 'data', null),
      ],
    );

    blocTest(
      'with throw FirebaseException',
      build: () => productCubit,
      act: (bloc) => bloc.getProduct(''),
      setUp: () {
        when(() => productRepository.findProduct(any())).thenThrow(
          FirebaseException(plugin: '', message: 'failed get product'),
        );
      },
      expect: () => [
        isA<StateHelper>().having((p0) => p0.status, 'status', Status.loading),
        isA<StateHelper<Product>>().having((p0) => p0.status, 'status', Status.error).having((p0) => p0.message, 'message', 'failed get product'),
      ],
    );

    blocTest(
      'with throw Exception',
      build: () => productCubit,
      act: (bloc) => bloc.getProduct(''),
      setUp: () {
        when(() => productRepository.findProduct(any())).thenThrow(
          Exception('failed get product'),
        );
      },
      expect: () => [
        isA<StateHelper>().having((p0) => p0.status, 'status', Status.loading),
        isA<StateHelper<Product>>()
            .having((p0) => p0.status, 'status', Status.error)
            .having((p0) => p0.message, 'message', 'Exception: failed get product'),
      ],
    );
  });

  group('emit removeProduct', () {
    blocTest(
      'with return correct value',
      build: () => productCubit,
      act: (bloc) => bloc.removeProduct(const Product(id: '123')),
      setUp: () {
        when(() => productRepository.removeProduct(any())).thenAnswer((_) async => {});
      },
      expect: () => [
        isA<StateHelper>().having((p0) => p0.status, 'status', Status.loading),
        isA<StateHelper<Product>>().having((p0) => p0.status, 'status', Status.loaded).having((p0) => p0.data, 'data', null),
      ],
    );

    blocTest(
      'with seed data and return correct value',
      build: () => productCubit,
      act: (bloc) => bloc.removeProduct(const Product(id: '123')),
      seed: () => const StateHelper<Product>(status: Status.loaded, data: Product(id: '123')),
      setUp: () {
        when(() => productRepository.removeProduct(any())).thenAnswer((_) async => {});
      },
      expect: () => [
        isA<StateHelper<Product>>().having((p0) => p0.status, 'status', Status.loading),
        isA<StateHelper<Product>>().having((p0) => p0.status, 'status', Status.loaded).having((p0) => p0.data?.id, 'data', '123'),
      ],
    );

    blocTest(
      'with throw FirebaseException',
      build: () => productCubit,
      act: (bloc) => bloc.removeProduct(const Product(id: '123')),
      setUp: () {
        when(() => productRepository.removeProduct(any())).thenThrow(
          FirebaseException(plugin: '', message: 'failed get product'),
        );
      },
      expect: () => [
        isA<StateHelper>().having((p0) => p0.status, 'status', Status.loading),
        isA<StateHelper<Product>>().having((p0) => p0.status, 'status', Status.error).having((p0) => p0.message, 'message', 'failed get product'),
      ],
    );

    blocTest(
      'with throw Exception',
      build: () => productCubit,
      act: (bloc) => bloc.removeProduct(const Product(id: '123')),
      setUp: () {
        when(() => productRepository.removeProduct(any())).thenThrow(
          Exception('failed get product'),
        );
      },
      expect: () => [
        isA<StateHelper>().having((p0) => p0.status, 'status', Status.loading),
        isA<StateHelper<Product>>()
            .having((p0) => p0.status, 'status', Status.error)
            .having((p0) => p0.message, 'message', 'Exception: failed get product'),
      ],
    );
  });

  group('emit addProduct', () {
    blocTest(
      'without photo and return correct value',
      build: () => productCubit,
      act: (bloc) => bloc.addProduct(product: const Product(id: '123')),
      setUp: () {
        when(() => productRepository.createProduct(any())).thenAnswer((_) async => {});
      },
      expect: () => [
        isA<StateHelper>().having((p0) => p0.status, 'status', Status.loading),
        isA<StateHelper<Product>>().having((p0) => p0.status, 'status', Status.loaded).having((p0) => p0.data?.id, 'id', '123'),
      ],
    );

    blocTest(
      'with photo and return correct value',
      build: () => productCubit,
      act: (bloc) => bloc.addProduct(product: const Product(id: '123'), file: File('')),
      setUp: () {
        when(() => storageRepository.addPhoto(any())).thenAnswer((_) async => 'photo_url_location');
        when(() => productRepository.createProduct(any())).thenAnswer((_) async => {});
      },
      expect: () => [
        isA<StateHelper>().having((p0) => p0.status, 'status', Status.loading),
        isA<StateHelper<Product>>()
            .having((p0) => p0.status, 'status', Status.loaded)
            .having((p0) => p0.data?.id, 'id', '123')
            .having((p0) => p0.data?.photo, 'photo', 'photo_url_location'),
      ],
      verify: (_) {
        verify(() => storageRepository.addPhoto(any())).called(1);
        verify(() => productRepository.createProduct(any())).called(1);
      },
    );

    blocTest(
      'with passing photo with null value',
      build: () => productCubit,
      act: (bloc) => bloc.addProduct(product: const Product(id: '123'), file: null),
      setUp: () {
        when(() => storageRepository.addPhoto(any())).thenAnswer((_) async => 'photo_url_location');
        when(() => productRepository.createProduct(any())).thenAnswer((_) async => {});
      },
      expect: () => [
        isA<StateHelper>().having((p0) => p0.status, 'status', Status.loading),
        isA<StateHelper<Product>>().having((p0) => p0.status, 'status', Status.loaded).having((p0) => p0.data?.id, 'id', '123')
      ],
      verify: (_) {
        verifyNever(() => storageRepository.addPhoto(any())).called(0);
        verify(() => productRepository.createProduct(any())).called(1);
      },
    );

    blocTest(
      'with throw FirebaseException',
      build: () => productCubit,
      act: (bloc) => bloc.addProduct(product: const Product(id: '123')),
      setUp: () {
        when(() => productRepository.createProduct(any())).thenThrow(
          FirebaseException(plugin: '', message: 'failed create product'),
        );
      },
      expect: () => [
        isA<StateHelper>().having((p0) => p0.status, 'status', Status.loading),
        isA<StateHelper<Product>>().having((p0) => p0.status, 'status', Status.error).having((p0) => p0.message, 'message', 'failed create product'),
      ],
    );

    blocTest(
      'with throw Exception',
      build: () => productCubit,
      act: (bloc) => bloc.addProduct(product: const Product(id: '123')),
      setUp: () {
        when(() => productRepository.createProduct(any())).thenThrow(
          Exception('failed get product'),
        );
      },
      expect: () => [
        isA<StateHelper>().having((p0) => p0.status, 'status', Status.loading),
        isA<StateHelper<Product>>()
            .having((p0) => p0.status, 'status', Status.error)
            .having((p0) => p0.message, 'message', 'Exception: failed get product'),
      ],
    );
  });

  group('emit updateProduct', () {
    blocTest(
      'without photo and return correct value',
      build: () => productCubit,
      act: (bloc) => bloc.updateProduct(product: const Product(id: '123')),
      setUp: () {
        when(() => productRepository.updateProduct(any())).thenAnswer((_) async => {});
      },
      expect: () => [
        isA<StateHelper>().having((p0) => p0.status, 'status', Status.loading),
        isA<StateHelper<Product>>().having((p0) => p0.status, 'status', Status.loaded).having((p0) => p0.data?.id, 'id', '123'),
      ],
    );

    blocTest(
      'with photo and return correct value',
      build: () => productCubit,
      act: (bloc) => bloc.updateProduct(product: const Product(id: '123', photo: 'photo_url_location'), file: File('')),
      setUp: () {
        when(() => storageRepository.removePhoto(any())).thenAnswer((_) async => {});
        when(() => storageRepository.addPhoto(any())).thenAnswer((_) async => 'photo_url_location');
        when(() => productRepository.updateProduct(any())).thenAnswer((_) async => {});
      },
      expect: () => [
        isA<StateHelper>().having((p0) => p0.status, 'status', Status.loading),
        isA<StateHelper<Product>>()
            .having((p0) => p0.status, 'status', Status.loaded)
            .having((p0) => p0.data?.id, 'id', '123')
            .having((p0) => p0.data?.photo, 'photo', 'photo_url_location'),
      ],
      verify: (_) {
        verify(() => storageRepository.addPhoto(any())).called(1);
        verify(() => storageRepository.removePhoto(any())).called(1);
        verify(() => productRepository.updateProduct(any())).called(1);
      },
    );

    blocTest(
      'with photo and product doesn\'t have photo before and return correct value',
      build: () => productCubit,
      act: (bloc) => bloc.updateProduct(product: const Product(id: '123'), file: File('')),
      setUp: () {
        when(() => storageRepository.addPhoto(any())).thenAnswer((_) async => 'photo_url_location');
        when(() => productRepository.updateProduct(any())).thenAnswer((_) async => {});
      },
      expect: () => [
        isA<StateHelper>().having((p0) => p0.status, 'status', Status.loading),
        isA<StateHelper<Product>>()
            .having((p0) => p0.status, 'status', Status.loaded)
            .having((p0) => p0.data?.id, 'id', '123')
            .having((p0) => p0.data?.photo, 'photo', 'photo_url_location'),
      ],
      verify: (_) {
        verify(() => storageRepository.addPhoto(any())).called(1);
        verifyNever(() => storageRepository.removePhoto(any())).called(0);
        verify(() => productRepository.updateProduct(any())).called(1);
      },
    );

    blocTest(
      'with passing photo with null value',
      build: () => productCubit,
      act: (bloc) => bloc.updateProduct(product: const Product(id: '123'), file: null),
      setUp: () {
        when(() => storageRepository.addPhoto(any())).thenAnswer((_) async => 'photo_url_location');
        when(() => productRepository.updateProduct(any())).thenAnswer((_) async => {});
      },
      expect: () => [
        isA<StateHelper>().having((p0) => p0.status, 'status', Status.loading),
        isA<StateHelper<Product>>().having((p0) => p0.status, 'status', Status.loaded).having((p0) => p0.data?.id, 'id', '123')
      ],
      verify: (_) {
        verifyNever(() => storageRepository.addPhoto(any())).called(0);
        verify(() => productRepository.updateProduct(any())).called(1);
      },
    );

    blocTest(
      'with throw FirebaseException',
      build: () => productCubit,
      act: (bloc) => bloc.updateProduct(product: const Product(id: '123')),
      setUp: () {
        when(() => productRepository.updateProduct(any())).thenThrow(
          FirebaseException(plugin: '', message: 'failed create product'),
        );
      },
      expect: () => [
        isA<StateHelper>().having((p0) => p0.status, 'status', Status.loading),
        isA<StateHelper<Product>>().having((p0) => p0.status, 'status', Status.error).having((p0) => p0.message, 'message', 'failed create product'),
      ],
    );

    blocTest(
      'with throw Exception',
      build: () => productCubit,
      act: (bloc) => bloc.updateProduct(product: const Product(id: '123')),
      setUp: () {
        when(() => productRepository.updateProduct(any())).thenThrow(
          Exception('failed get product'),
        );
      },
      expect: () => [
        isA<StateHelper>().having((p0) => p0.status, 'status', Status.loading),
        isA<StateHelper<Product>>()
            .having((p0) => p0.status, 'status', Status.error)
            .having((p0) => p0.message, 'message', 'Exception: failed get product'),
      ],
    );
  });
}
