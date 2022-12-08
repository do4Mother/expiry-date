import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class StorageRepository {
  final _storage = FirebaseStorage.instance;

  Future<String> addPhoto(File file) async {
    final uploadTask = await _storage.ref('product/${basename(file.path)}').putFile(file);
    return uploadTask.ref.getDownloadURL();
  }

  Future<void> removePhoto(String url) {
    return _storage.refFromURL(url).delete();
  }
}
