import 'package:bloc_test/bloc_test.dart';
import 'package:expiry/models/product.dart';
import 'package:expiry/utils/streamed_list.dart';
import 'package:expiry/views/home/bloc/list_product/list_product_bloc.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helper/repositories.dart';

void main() {
  late ListProductBloc listProductBloc;
  late MockProfileRepository mockProfileRepository;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    mockProductRepository = MockProductRepository();

    listProductBloc = ListProductBloc(
      profileRepository: mockProfileRepository,
      productRepository: mockProductRepository,
    );
  });

  group('ListProductBloc Test', () {
    blocTest(
      'emit GetListProduct with correct situations',
      build: () => listProductBloc,
      setUp: () {
        final user = MockUser(uid: '1234');
        final auth = MockFirebaseAuth(mockUser: user);

        when(() => mockProfileRepository.getUserAccount()).thenAnswer((_) {
          return auth.currentUser;
        });

        final listProduct = [Product(id: '123', name: 'abc', expDate: DateTime.now())];
        final futureProducts = Future.value(listProduct);
        when(() => mockProductRepository.getProducts()).thenAnswer((_) => futureProducts);
        when(() => mockProductRepository.products).thenAnswer((_) => StreamedList());
      },
      act: (bloc) => bloc.add(GetListProduct()),
      expect: () => [const ListProductLoaded(data: [])],
    );

    blocTest(
      'emit GetListProduct with failed to get products',
      build: () => listProductBloc,
      setUp: () {
        final user = MockUser(uid: '1234');
        final auth = MockFirebaseAuth(mockUser: user);

        when(() => mockProfileRepository.getUserAccount()).thenAnswer((_) {
          return auth.currentUser;
        });

        when(() => mockProductRepository.getProducts()).thenThrow(FirebaseException(plugin: '', message: 'error'));
      },
      act: (bloc) => bloc.add(GetListProduct()),
      expect: () => [isA<ListProductError>().having((p0) => p0.message, 'error message', 'error')],
    );
  });
}
