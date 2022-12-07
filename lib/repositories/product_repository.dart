import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expiry/models/product.dart';

class ProductRepository {
  Future<ProductQuerySnapshot> getProducts({String? profileId}) {
    final q = productRef;

    if (profileId != null) {
      q.whereFieldPath(FieldPath.fromString('profile.id'), isEqualTo: profileId);
    }

    return q.get();
  }

  Future<void> createProduct(Product product) async {
    final addProduct = await productRef.add(product);
    return addProduct.update(id: addProduct.id);
  }

  Future<void> updateProduct(Product product) {
    return productRef.doc(product.id).set(product.copyWith(updatedAt: DateTime.now()));
  }
}
