import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expiry/models/product.dart';
import 'package:expiry/utils/streamed_list.dart';

class ProductRepository {
  final products = StreamedList<Product>();

  Future<List<Product>> getProducts({String? profileId, bool? isSale}) async {
    final ref = productRef;
    var query = ref.whereFieldPath(FieldPath.fromString('profile.id'), isEqualTo: profileId);

    if (isSale != null) {
      query = query.whereIsSale(isEqualTo: isSale);
    }

    final getProducts = await query.get();
    return getProducts.docs.map((e) => e.data).toList();
  }

  Future<void> createProduct(Product product) async {
    final addProduct = await productRef.add(product);
    await addProduct.update(id: addProduct.id);

    // update product stream
    products.addToList(product.copyWith(id: addProduct.id));
  }

  Future<void> updateProduct(Product product) async {
    final updatedProduct = product.copyWith(updatedAt: DateTime.now());
    await productRef.doc(product.id).set(updatedProduct);

    // update product stream
    var updateStreamProduct = List<Product>.from(products.list);
    final getUpdatedIndex = updateStreamProduct.indexWhere((element) => element.id == product.id);
    if (getUpdatedIndex >= 0) {
      updateStreamProduct[getUpdatedIndex] = updatedProduct;
      products.updateList(updateStreamProduct);
    }
  }

  Future<Product?> findProduct(String id) async {
    final getProduct = await productRef.doc(id).get();
    return getProduct.data;
  }

  Future<void> removeProduct(String id) async {
    await productRef.doc(id).delete();

    // update product stream
    var updateStreamProduct = List<Product>.from(products.list);
    updateStreamProduct.removeWhere((element) => element.id == id);
    products.updateList(updateStreamProduct);
  }
}
