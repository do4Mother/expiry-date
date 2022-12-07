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
  final Priority priority;
  @JsonKey(name: 'exp_date')
  final DateTime expDate;
  final Profile? profile;

  const Product({
    required this.id,
    this.createdAt,
    this.updatedAt,
    required this.name,
    required this.expDate,
    this.priority = Priority.low,
    this.profile,
  });

  @override
  List<Object?> get props => [id, createdAt, updatedAt, name, expDate, priority];

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

enum Priority { low, medium, high }

@Collection<Product>('products')
final productRef = ProductCollectionReference();
