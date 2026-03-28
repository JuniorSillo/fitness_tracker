import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';


class ProfileRepository {
  static const String _key = 'user_profile';

  /// Saves the entire profile as a single JSON string.
  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(profile.toJson()));
  }

  /// Loads the profile from disk. Returns defaults on missing or corrupted data.
  Future<UserProfile> loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null) return UserProfile.defaults();
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return UserProfile.fromJson(json);
    } catch (_) {
      // Corrupted JSON — fall back to defaults rather than crash.
      return UserProfile.defaults();
    }
  }

  /// Removes only the profile key. Preference keys are separate if any remain.
  Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
