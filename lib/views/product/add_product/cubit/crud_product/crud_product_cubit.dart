import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expiry/models/product.dart';
import 'package:expiry/repositories/product_repository.dart';
import 'package:expiry/repositories/storage_repository.dart';
import 'package:firebase_core/firebase_core.dart';

part 'crud_product_state.dart';

class CRUDProductCubit extends Cubit<CRUDProductState> {
  final ProductRepository _productRepository;
  final StorageRepository _storageRepository;

  CRUDProductCubit({required ProductRepository productRepository, required StorageRepository storageRepository})
      : _productRepository = productRepository,
        _storageRepository = storageRepository,
        super(CRUDProductInitial());

  Future<void> addProduct({required Product product, File? file}) async {
    emit(CRUDProductLoading());

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

      emit(CRUDProductLoaded());
    } on FirebaseException catch (e) {
      emit(CRUDProductError(message: e.message ?? ''));
    }
  }
}
