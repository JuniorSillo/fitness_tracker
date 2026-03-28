import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exercise.dart';


class RoutineRepository {
  static const String _key = 'user_routine';

  /// Saves the entire routine as a single JSON array string.
  Future<void> saveRoutine(List<Exercise> routine) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(routine.map((e) => e.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  /// Loads the routine. Returns empty list on missing or corrupted data.
  Future<List<Exercise>> loadRoutine() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Removes the routine key from SharedPreferences.
  Future<void> clearRoutine() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
