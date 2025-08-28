import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'app_enums.dart';
import 'storage_config.dart';

class JwtConfig {
  JwtConfig._();
  // Secret key
  static String _key = 'hello';

  // Storage keys
  static const String userTokenKey = 'userToken';
  static const String userStatusKey = 'userStatus';

  static JWT? _verifyToken(String token) {
    return JWT.tryVerify(token, SecretKey(_key));
  }

  static DateTime expiryTime(String token) {
    return JwtDecoder.getExpirationDate(token);
  }

  // Store token
  static String? storeUserToken(String? token) {
    // JWT? jwtToken = _verifyToken(token);
    // if (jwtToken != null) {
    LocalStorage.storeValue(StorageKey.token, token);
    // }
    return token;
  }

  // Fetch local token
  static Future<String?> fetchLocalUserToken() async {
    String? token = await LocalStorage.fetchValue(StorageKey.token);
    // if (token != null) {
    //   return _verifyToken(token);
    // }
    return token;
  }

  // Fetch local token
  static Future<void> removeLocalUserToken() async {
    LocalStorage.removeValue(StorageKey.token);
    // if (token != null) {
    //   return _verifyToken(token);
    // }
  }
}
