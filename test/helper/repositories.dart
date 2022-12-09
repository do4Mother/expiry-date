import 'package:expiry/models/profile.dart';
import 'package:expiry/repositories/product_repository.dart';
import 'package:expiry/repositories/profile_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {
  @override
  Future<void> updateProfile(Profile profile) {
    return Future.value();
  }
}

class MockProductRepository extends Mock implements ProductRepository {}
