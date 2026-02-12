import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for local key-value storage using SharedPreferences.
class LocalStorageService {
  SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // --- String List operations ---

  Future<List<String>> getStringList(String key) async {
    final p = await prefs;
    return p.getStringList(key) ?? [];
  }

  Future<void> setStringList(String key, List<String> value) async {
    final p = await prefs;
    await p.setStringList(key, value);
  }

  // --- JSON List operations (for complex objects) ---

  Future<List<Map<String, dynamic>>> getJsonList(String key) async {
    final p = await prefs;
    final raw = p.getString(key);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Future<void> setJsonList(String key, List<Map<String, dynamic>> value) async {
    final p = await prefs;
    await p.setString(key, jsonEncode(value));
  }

  // --- Generic operations ---

  Future<void> remove(String key) async {
    final p = await prefs;
    await p.remove(key);
  }
}
