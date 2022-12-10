import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expiry/models/product.dart';
import 'package:expiry/repositories/product_repository.dart';
import 'package:expiry/repositories/profile_repository.dart';
import 'package:expiry/utils/state_helper.dart';
import 'package:firebase_core/firebase_core.dart';

part 'list_product_event.dart';

class ListProductBloc extends Bloc<ListProductEvent, StateHelper<List<Product>>> {
  final ProfileRepository _profileRepository;
  final ProductRepository _productRepository;

  ListProductBloc({required ProfileRepository profileRepository, required ProductRepository productRepository})
      : _profileRepository = profileRepository,
        _productRepository = productRepository,
        super(const StateHelper()) {
    on<GetListProduct>(_getListProduct);
  }

  FutureOr<void> _getListProduct(GetListProduct event, Emitter<StateHelper> emit) async {
    try {
      final user = _profileRepository.getUserAccount();
      final getProducts = await _productRepository.getProducts(profileId: user?.uid);
      _productRepository.products.updateList(getProducts);
      emit(state.copyWith(status: Status.loaded, data: getProducts));

      await emit.forEach(
        _productRepository.products.data,
        onData: (data) {
          return state.copyWith(status: Status.loaded, data: data);
        },
      );
    } on FirebaseException catch (e) {
      emit(state.copyWith(status: Status.error, message: e.message ?? ''));
    } catch (e) {
      emit(state.copyWith(status: Status.error, message: e.toString()));
    }
  }
}
