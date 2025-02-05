
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

/// Service for local storage (SharedPreferences)
class LocalStorageService {
  final SharedPreferences _prefs;

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
}
