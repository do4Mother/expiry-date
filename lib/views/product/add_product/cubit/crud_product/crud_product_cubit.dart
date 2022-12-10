import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:expiry/models/product.dart';
import 'package:expiry/repositories/product_repository.dart';
import 'package:expiry/repositories/storage_repository.dart';
import 'package:expiry/utils/state_helper.dart';
import 'package:firebase_core/firebase_core.dart';

class CRUDProductCubit extends Cubit<StateHelper<Product>> {
  final ProductRepository _productRepository;
  final StorageRepository _storageRepository;

  CRUDProductCubit({required ProductRepository productRepository, required StorageRepository storageRepository})
      : _productRepository = productRepository,
        _storageRepository = storageRepository,
        super(const StateHelper());

  Future<void> addProduct({required Product product, File? file}) async {
    emit(state.copyWith(status: Status.loading));

    try {
      String? fileUrl;
      if (file != null) {
        fileUrl = await _storageRepository.addPhoto(file);
      }

      final data = product.copyWith(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        photo: fileUrl,
      );

      await _productRepository.createProduct(data);

      emit(state.copyWith(status: Status.loaded, data: data));
    } on FirebaseException catch (e) {
      emit(state.copyWith(status: Status.error, message: e.message ?? ''));
    } catch (e) {
      emit(state.copyWith(status: Status.error, message: e.toString()));
    }
  }

  Future<void> updateProduct({required Product product, File? file}) async {
    emit(state.copyWith(status: Status.loading));

    try {
      String? fileUrl;

      if (file != null) {
        if (product.photo?.isNotEmpty ?? false) {
          await _storageRepository.removePhoto(product.photo!);
        }
        fileUrl = await _storageRepository.addPhoto(file);
      }

      final data = product.copyWith(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        photo: fileUrl,
      );

      await _productRepository.updateProduct(data);

      emit(state.copyWith(status: Status.loaded, data: data));
    } on FirebaseException catch (e) {
      emit(state.copyWith(status: Status.error, message: e.message ?? ''));
    } catch (e) {
      emit(state.copyWith(status: Status.error, message: e.toString()));
    }
  }

  Future<void> getProduct(String id) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final product = await _productRepository.findProduct(id);
      emit(state.copyWith(status: Status.loaded, data: product));
    } on FirebaseException catch (e) {
      emit(state.copyWith(status: Status.error, message: e.message ?? ''));
    } catch (e) {
      emit(state.copyWith(status: Status.error, message: e.toString()));
    }
  }
}
