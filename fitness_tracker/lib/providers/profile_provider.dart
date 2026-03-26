import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  // Storage keys 
  static const String _keyName         = 'profile_name';
  static const String _keyAge          = 'profile_age';
  static const String _keyWeightGoal   = 'profile_weight_goal';
  static const String _keyWeightUnit   = 'pref_weight_unit';
  static const String _keyRestTimer    = 'pref_rest_timer';
  static const String _keyNotifications = 'pref_notifications';

  //  Private state (defaults) 
  String _name              = 'Guest';
  int    _age               = 0;
  double _weightGoal        = 0.0;
  String _weightUnit        = 'kg';
  int    _restTimer         = 60;
  bool   _notificationsEnabled = true;

  // Public getters
  String get name               => _name;
  int    get age                => _age;
  double get weightGoal         => _weightGoal;
  String get weightUnit         => _weightUnit;
  int    get restTimer          => _restTimer;
  bool   get notificationsEnabled => _notificationsEnabled;

  // Constructor
  ProfileProvider() {
    _loadAll();
  }

  // Load from disk
  Future<void> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();

    // Profile data
    _name = prefs.getString(_keyName) ?? 'Guest';

    final rawAge = prefs.getInt(_keyAge) ?? 0;
    _age = (rawAge < 0 || rawAge > 120) ? 0 : rawAge;

    final rawGoal = prefs.getDouble(_keyWeightGoal) ?? 0.0;
    _weightGoal = rawGoal < 0 ? 0.0 : rawGoal;

    // Preferences
    final rawUnit = prefs.getString(_keyWeightUnit) ?? 'kg';
    _weightUnit = (rawUnit == 'kg' || rawUnit == 'lbs') ? rawUnit : 'kg';

    final rawTimer = prefs.getInt(_keyRestTimer) ?? 60;
    _restTimer = rawTimer.clamp(15, 300);

    _notificationsEnabled = prefs.getBool(_keyNotifications) ?? true;

    notifyListeners();
  }

  // Individual save methods 
  Future<void> saveName(String name) async {
    _name = name.trim().isEmpty ? 'Guest' : name.trim();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, _name);
  }

  Future<void> saveAge(int age) async {
    _age = (age < 0 || age > 120) ? 0 : age;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyAge, _age);
  }

  Future<void> saveWeightGoal(double goal) async {
    _weightGoal = goal < 0 ? 0.0 : goal;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyWeightGoal, _weightGoal);
  }

  Future<void> saveWeightUnit(String unit) async {
    if (unit != 'kg' && unit != 'lbs') return;
    _weightUnit = unit;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyWeightUnit, _weightUnit);
  }

  Future<void> saveRestTimer(int seconds) async {
    _restTimer = seconds.clamp(15, 300);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyRestTimer, _restTimer);
  }

  Future<void> saveNotifications(bool enabled) async {
    _notificationsEnabled = enabled;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotifications, _notificationsEnabled);
  }

  // Extra credit for selective resets 

  /// Wipes ONLY profile data 
  Future<void> resetProfile() async {
    _name       = 'Guest';
    _age        = 0;
    _weightGoal = 0.0;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyName);
    await prefs.remove(_keyAge);
    await prefs.remove(_keyWeightGoal);
  }

  /// Wipes ALL data, both profile and preferences.
  Future<void> resetEverything() async {
    _name                = 'Guest';
    _age                 = 0;
    _weightGoal          = 0.0;
    _weightUnit          = 'kg';
    _restTimer           = 60;
    _notificationsEnabled = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
