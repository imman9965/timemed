import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Save Token
  Future<void> saveToken(String token) async {
    await _storage.write(key: "auth_token", value: token);
  }

  /// Get Token
  Future<String?> getToken() async {
    return await _storage.read(key: "auth_token");
  }

  /// Save Refresh Token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: "refresh_token", value: token);
  }

  /// Get Refresh Token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: "refresh_token");
  }

  /// Save User Role
  Future<void> saveRole(String role) async {
    await _storage.write(key: "user_role", value: role);
  }

  /// Get User Role
  Future<String?> getRole() async {
    return await _storage.read(key: "user_role");
  }

  /// Clear All
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Logout
  Future<void> logout() async {
    await clearAll();
  }
}
