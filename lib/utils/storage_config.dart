import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

import 'app_enums.dart';

class LocalStorage {
  LocalStorage._();
  static final GetStorage _getStorage = GetStorage();

  // Store
  static Future<bool> storeValue(StorageKey key, dynamic value) =>
      _getStorage.write(key.name, value).then((value) => true).onError((error, stackTrace) {
        debugPrint(error.toString());
        return false;
      });

  // Fetch
  static Future<dynamic> fetchValue(StorageKey key) async {
    return _getStorage.read(key.name);
  }

  // Remove
  static Future<void> removeValue(StorageKey key) async {
    return await _getStorage.remove(key.name);
  }

  // Clear
  static Future<bool> erase() => GetStorage().erase().then((value) => true).onError((error, stackTrace) {
        debugPrint(error.toString());
        return false;
      });
}
