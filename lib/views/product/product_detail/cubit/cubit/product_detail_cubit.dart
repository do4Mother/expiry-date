import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expiry/models/product.dart';
import 'package:expiry/repositories/product_repository.dart';
import 'package:firebase_core/firebase_core.dart';

part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final ProductRepository _productRepository;

  ProductDetailCubit({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ProductDetailInitial());

  getProduct(String id) async {
    emit(ProductDetailLoading());
    try {
      final product = await _productRepository.findProduct(id);
      emit(ProductDetailLoaded(product: product.data!));
    } on FirebaseException catch (e) {
      emit(ProductDetailError(message: e.message ?? ''));
    }
  }
}
