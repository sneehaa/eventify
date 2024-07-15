import 'dart:convert';

import 'package:eventify/core/storage/flutter_secure_storage.dart';
import 'package:eventify/features/models/event_models.dart';
import 'package:eventify/features/models/promo_modal.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl;
  final String deleteUrl;
  final String editUrl;
  final SecureStorage secureStorage;

  UserService({
    required this.baseUrl,
    required this.deleteUrl,
    required this.editUrl,
    required this.secureStorage,
  });

  Future<Map<String, dynamic>> fetchUserData(String userId) async {
    try {
      final token = await secureStorage.readToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData.containsKey('userProfile')) {
          return responseData['userProfile'];
        } else {
          throw Exception('userProfile key not found in response');
        }
      } else {
        throw Exception(
            'Failed to load user data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      throw Exception('Failed to load user data');
    }
  }

  Future<List<Event>> fetchUserEvents(String userId) async {
    final url = '$baseUrl/events/user/$userId';
    print('Fetching user events from $url');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${await secureStorage.readToken()}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['events'];
      return data.map((event) => Event.fromJson(event)).toList();
    } else {
      throw Exception('Error fetching user events');
    }
  }

  Future<void> updateUserData(
      String userId, Map<String, dynamic> userData) async {
    try {
      final token = await secureStorage.readToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.put(
        Uri.parse('$editUrl/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        print('User data updated successfully');
      } else {
        print(
            'Failed to update user data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to update user data');
      }
    } catch (e) {
      print('Failed to update user data: $e');
      throw Exception('Failed to update user data');
    }
  }

  Future<void> deleteAccount(String userId) async {
    try {
      final token = await secureStorage.readToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.delete(
        Uri.parse('$deleteUrl/$userId'),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await secureStorage.deleteToken();
      } else {
        throw Exception('Failed to delete account');
      }
    } catch (e) {
      print('Error deleting account: $e');
      throw Exception('Failed to delete account');
    }
  }

  Future<List<Event>> getFavoriteEvents() async {
    try {
      final token = await secureStorage.readToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/favorite-events'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse response body
        List<dynamic> data = jsonDecode(response.body);
        List<Event> events = data.map((item) => Event.fromJson(item)).toList();
        return events;
      } else {
        throw Exception(
            'Failed to fetch favorite events: ${response.statusCode}');
      }
    } catch (e) {
      // Log the error for debugging purposes
      logger.e('Failed to fetch favorite events', error: e);
      throw Exception('Failed to fetch favorite events: $e');
    }
  }

  Future<void> toggleFavorite(String eventId) async {
    final url = '$baseUrl/favorites/remove/$eventId';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${await secureStorage.readToken()}',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to toggle favorite: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }
}
