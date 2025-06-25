
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/models/user.dart';

/// Service for local storage (SharedPreferences)
class LocalStorageService {
  final SharedPreferences _prefs;
  static const _sharedSecretsPrefsKey = 'sharedSecrets';

  LocalStorageService(this._prefs);

  Future<void> saveUser(UserModel user) async {
    await _prefs.setString('userData', json.encode(user.toMap()));
    await _prefs.setBool('isLoggedIn', true);
  }

  Future<void> clearUser() async {
    await _prefs.remove('userData');
    await _prefs.setBool('isLoggedIn', false);
  }

  UserModel? getUser() {
    final userData = _prefs.getString('userData');
    if (userData == null) return null;

    final Map<String, dynamic> decodedData = json.decode(userData);
    return UserModel.fromMap(decodedData);
  }


  /// Saves a KeyPair to SharedPreferences.
  Future<void> saveKeyPair(Map<String, String> keyPairMap) async {
    final keyPairJson = json.encode(keyPairMap);
    await _prefs.setString('keyPair', keyPairJson);
  }

  /// Retrieves a KeyPair from SharedPreferences.
  Future<Map<String, String>?> getKeyPair() async {
    final keyPairJson = _prefs.getString('keyPair');
    if (keyPairJson == null) return null;
    return Map<String, String>.from(json.decode(keyPairJson));
  }

  /// Save or update the shared secret for a specific chat
  Future<void> saveSharedSecret(String chatId, String secretString) async {
    final all = await _getSharedSecretsMap();
    all[chatId] = secretString;
    await _prefs.setString(_sharedSecretsPrefsKey, json.encode(all));
  }

  /// Retrieve the shared secret for a specific chat, or null if absent
  Future<String?> getSharedSecret(String chatId) async {
    final all = await _getSharedSecretsMap();
    return all[chatId];
  }

  /// Internal helper to decode the shared-secrets JSON map
  Future<Map<String, String>> _getSharedSecretsMap() async {
    final jsonString = _prefs.getString(_sharedSecretsPrefsKey);
    if (jsonString == null) return {};
    final Map<String, dynamic> decoded = json.decode(jsonString);
    return decoded.map((k, v) => MapEntry(k, v as String));
  }
}


