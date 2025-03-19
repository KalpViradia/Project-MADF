import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_class.dart';

class ApiService {
  final String baseURL = 'https://66ed2084380821644cdb7fe9.mockapi.io/matrimony_app';

  // Fetch all users from API
  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse(baseURL));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((user) => User.fromMap(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Fetch a single user by ID (String ID)
  Future<User?> getUserById(String id) async {
    final response = await http.get(Uri.parse('$baseURL/$id'));

    if (response.statusCode == 200) {
      return User.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  // Add a new user with better error handling
  Future<User?> addUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse(baseURL),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toMap()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return User.fromMap(jsonDecode(response.body));
      } else {
        print('Error adding user: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  // Update an existing user (String ID)
  Future<User?> updateUser(String id, User user) async {
    final response = await http.put(
      Uri.parse('$baseURL/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toMap()),
    );

    if (response.statusCode == 200) {
      return User.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  // Delete a user by ID (String ID)
  Future<bool> deleteUser(String id) async {
    final response = await http.delete(Uri.parse('$baseURL/$id'));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete user');
    }
  }
}
