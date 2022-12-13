import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:expiry/utils/firestore_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@firestoreSerializable
@CopyWith()
class Profile extends Equatable {
  final String id;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @JsonKey(name: 'first_name')
  final String? firstName;
  @JsonKey(name: 'last_name')
  final String? lastName;
  @JsonKey(name: 'date_of_birth')
  final DateTime? dateOfBirth;
  final bool isAnonymous;
  final String? email;
  final Gender gender;

  const Profile({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.email,
    this.gender = Gender.other,
    this.isAnonymous = true,
  });

  @override
  List<Object?> get props => [id, createdAt, updatedAt, firstName, lastName, dateOfBirth, gender];

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}

enum Gender { male, female, other }

@Collection<Profile>('profiles')
final profileRef = ProfileCollectionReference();
