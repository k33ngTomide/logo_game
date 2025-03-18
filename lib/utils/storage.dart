import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _answeredLogosKey = 'answeredLogos';

  static Future<void> init() async {
    await SharedPreferences.getInstance();
  }

  /// Saves the answered logos in local storage.
  static Future<void> saveAnsweredLogos(Map<String, List<int>> answeredLogos) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String jsonData = jsonEncode(answeredLogos);
      await prefs.setString(_answeredLogosKey, jsonData);
    } catch (e) {
      print('Error saving answered logos: $e');
    }
  }

  /// Retrieves the answered logos from local storage.
  static Future<Map<String, List<int>>> getAnsweredLogos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final answeredLogosJson = prefs.getString(_answeredLogosKey);

      if (answeredLogosJson != null) {
        final decoded = jsonDecode(answeredLogosJson) as Map<String, dynamic>;

        return decoded.map(
              (key, value) => MapEntry(key, List<int>.from(value)),
        );
      }
    } catch (e) {
      print('Error loading answered logos: $e');
    }

    // Default structure
    return {
      'sport': [],
      'tech': [],
      'food': [],
      'cars': [],
      'fashion': [],
      'movies': [],
    };
  }

  /// Clears all answered logos from storage.
  static Future<void> resetAnsweredLogos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_answeredLogosKey);
    } catch (e) {
      print('Error resetting answered logos: $e');
    }
  }
}
