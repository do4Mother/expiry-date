import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expiry/models/product.dart';
import 'package:expiry/repositories/product_repository.dart';
import 'package:expiry/repositories/storage_repository.dart';
import 'package:firebase_core/firebase_core.dart';

part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  final ProductRepository _productRepository;
  final StorageRepository _storageRepository;

  AddProductCubit({required ProductRepository productRepository, required StorageRepository storageRepository})
      : _productRepository = productRepository,
        _storageRepository = storageRepository,
        super(AddProductInitial());

  Future<void> addProduct({required Product product, File? file}) async {
    emit(AddProductLoading());

    try {
      String? fileUrl;
      if (file != null) {
        fileUrl = await _storageRepository.addPhoto(file);
      }

      await _productRepository.createProduct(product.copyWith(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        photo: fileUrl,
      ));

      emit(AddProductLoaded());
    } on FirebaseException catch (e) {
      emit(AddProductError(message: e.message ?? ''));
    }
  }
}
