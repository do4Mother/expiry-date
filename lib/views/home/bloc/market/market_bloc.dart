import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expiry/models/product.dart';
import 'package:expiry/repositories/product_repository.dart';
import 'package:expiry/utils/state_helper.dart';
import 'package:firebase_core/firebase_core.dart';

part 'market_event.dart';

class MarketBloc extends Bloc<MarketEvent, StateHelper<List<Product>>> {
  final ProductRepository _productRepository;

  MarketBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(const StateHelper()) {
    on<GetMarketProduct>(_getMarketProduct);
  }

  FutureOr<void> _getMarketProduct(GetMarketProduct event, Emitter<StateHelper<List<Product>>> emit) async {
    try {
      final data = await _productRepository.getProducts(isSale: true);
      emit(
        state.copyWith(status: Status.loaded, data: data),
      );
    } on FirebaseException catch (e) {
      emit(
        state.copyWith(status: Status.error, message: e.message),
      );
    } catch (e) {
      emit(
        state.copyWith(status: Status.error, message: e.toString()),
      );
    }
  }
}
