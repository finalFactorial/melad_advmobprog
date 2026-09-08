import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/user.dart';

class UserService {
  static const String keyUserToken = 'user_access_token';
  static const String keyUserData = 'user_data_json';

  /// Authenticate user via DummyJSON /user/login endpoint
  Future<User?> login(String username, String password) async {
    try {
      final uri = Uri.parse('$host/user/login');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'expiresInMins': 60,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final int userId = data['id'] ?? 1;
        final token = data['accessToken'] ?? data['token'] ?? '';
        
        // Fetch full profile details (address, company, university) from /users/$id
        User fullUser = User.fromJson(data);
        try {
          final userDetailRes = await http.get(Uri.parse('$host/users/$userId')).timeout(const Duration(seconds: 4));
          if (userDetailRes.statusCode == 200) {
            fullUser = User.fromJson(jsonDecode(userDetailRes.body));
          }
        } catch (_) {}

        await saveUserSession(fullUser, token);
        return fullUser;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Save user model and auth token to SharedPreferences
  Future<void> saveUserSession(User user, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUserToken, token);
    await prefs.setString(keyUserData, jsonEncode(user.toJson()));
  }

  /// Get current saved user from SharedPreferences
  Future<User?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(keyUserData);
    if (userJson != null && userJson.isNotEmpty) {
      try {
        final Map<String, dynamic> data = jsonDecode(userJson);
        return User.fromJson(data);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  /// Check if user has active session token in SharedPreferences
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(keyUserToken);
    return token != null && token.isNotEmpty;
  }

  /// Logout and clear user session
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyUserToken);
    await prefs.remove(keyUserData);
  }

  Future<User> getUserById(int id) async {
    try {
      final uri = Uri.parse('$host/users/$id');
      final response = await http.get(uri).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        return (await getSavedUser()) ?? User.sampleUser;
      }
    } catch (_) {
      return (await getSavedUser()) ?? User.sampleUser;
    }
  }

  Future<User> getCurrentUser() async {
    return (await getSavedUser()) ?? User.sampleUser;
  }
}
