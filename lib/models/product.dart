import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:expiry/models/profile.dart';
import 'package:expiry/utils/firestore_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@firestoreSerializable
@CopyWith()
class Product extends Equatable {
  final String id;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  final String name;
  final ProductPriority priority;
  @JsonKey(name: 'exp_date')
  final DateTime expDate;
  @JsonKey(name: 'place_detail')
  final String? placeDetail;
  final String? descriptions;
  final double? price;
  @JsonKey(name: 'is_sell')
  final bool isSale;
  final String? photo;
  final Profile? profile;

  const Product({
    required this.id,
    this.createdAt,
    this.updatedAt,
    required this.name,
    required this.expDate,
    this.priority = ProductPriority.low,
    this.placeDetail,
    this.descriptions,
    this.price,
    this.isSale = false,
    this.photo,
    this.profile,
  });

  @override
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        name,
        placeDetail,
        descriptions,
        expDate,
        priority,
        price,
      ];

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

enum ProductPriority { low, medium, high }

@Collection<Product>('products')
final productRef = ProductCollectionReference();
