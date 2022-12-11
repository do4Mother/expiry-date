import 'dart:io';

import 'package:expiry/models/product.dart';
import 'package:expiry/models/profile.dart';
import 'package:mocktail/mocktail.dart';

class FakeProfile extends Fake implements Profile {}

class FakeProduct extends Fake implements Product {}

class FakeFile extends Fake implements File {}