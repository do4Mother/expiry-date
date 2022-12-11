import 'package:expiry/repositories/product_repository.dart';
import 'package:expiry/repositories/profile_repository.dart';
import 'package:expiry/repositories/storage_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

class MockProductRepository extends Mock implements ProductRepository {}

class MockStorageRepository extends Mock implements StorageRepository {}
