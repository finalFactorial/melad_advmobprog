import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/user.dart';

class UserService {
  Future<User> getUserById(int id) async {
    try {
      final uri = Uri.parse('$host/users/$id');
      final response = await http.get(uri).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        return User.sampleUser;
      }
    } catch (_) {
      return User.sampleUser;
    }
  }

  Future<User> getCurrentUser() async {
    return User.sampleUser;
  }
}
