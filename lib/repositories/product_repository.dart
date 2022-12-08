import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expiry/models/product.dart';
import 'package:expiry/utils/streamed_list.dart';

class ProductRepository {
  final products = StreamedList<Product>();

  Future<ProductQuerySnapshot> getProducts({String? profileId}) {
    final q = productRef;

    if (profileId != null) {
      q.whereFieldPath(FieldPath.fromString('profile.id'), isEqualTo: profileId);
    }

    return q.get();
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
    final getUpdatedIndex = updateStreamProduct.indexOf(updatedProduct);
    updateStreamProduct[getUpdatedIndex] = updatedProduct;
    products.updateList(updateStreamProduct);
  }

  Future<ProductDocumentSnapshot> findProduct(String id) {
    return productRef.doc(id).get();
  }
}
