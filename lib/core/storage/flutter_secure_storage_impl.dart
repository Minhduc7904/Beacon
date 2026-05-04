import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'secure_storage.dart';

class FlutterSecureStorageImpl implements SecureStorage {
  final FlutterSecureStorage _storage;

  FlutterSecureStorageImpl(this._storage);

  @override
  Future<void> write(String key, String value) {
    return _storage.write(key: key, value: value);
  }

  @override
  Future<String?> read(String key) {
    return _storage.read(key: key);
  }

  @override
  Future<void> delete(String key) {
    return _storage.delete(key: key);
  }

  @override
  Future<void> deleteAll() {
    return _storage.deleteAll();
  }
}
