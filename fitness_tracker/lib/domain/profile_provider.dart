import 'package:flutter/foundation.dart';
import '../data/profile_repository.dart';
import '../models/user_profile.dart';


class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repository;

  UserProfile _profile = UserProfile.defaults();

  ProfileProvider(this._repository) {
    _init();
  }

  // Getters 
  UserProfile get profile           => _profile;
  String      get name              => _profile.name;
  int         get age               => _profile.age;
  double      get weightGoal        => _profile.weightGoal;
  String      get weightUnit        => _profile.weightUnit;
  int         get restTimer         => _profile.restTimerSeconds;
  bool        get notificationsEnabled => _profile.notificationsEnabled;
  bool        get isMetric          => _profile.weightUnit == 'kg';

  //  Init 
  Future<void> _init() async {
    _profile = await _repository.loadProfile();
    notifyListeners();
  }

  // from Update methods to copyWith to notify then  persist
  Future<void> updateName(String name) async {
    _profile = _profile.copyWith(
      name: name.trim().isEmpty ? 'Guest' : name.trim(),
    );
    notifyListeners();
    await _repository.saveProfile(_profile);
  }

  Future<void> updateAge(int age) async {
    _profile = _profile.copyWith(age: (age < 0 || age > 120) ? 0 : age);
    notifyListeners();
    await _repository.saveProfile(_profile);
  }

  Future<void> updateWeightGoal(double goal) async {
    _profile = _profile.copyWith(weightGoal: goal < 0 ? 0.0 : goal);
    notifyListeners();
    await _repository.saveProfile(_profile);
  }

  Future<void> updateWeightUnit(String unit) async {
    if (unit != 'kg' && unit != 'lbs') return;
    _profile = _profile.copyWith(weightUnit: unit);
    notifyListeners();
    await _repository.saveProfile(_profile);
  }

  Future<void> updateRestTimer(int seconds) async {
    _profile = _profile.copyWith(restTimerSeconds: seconds.clamp(15, 300));
    notifyListeners();
    await _repository.saveProfile(_profile);
  }

  Future<void> updateNotifications(bool enabled) async {
    _profile = _profile.copyWith(notificationsEnabled: enabled);
    notifyListeners();
    await _repository.saveProfile(_profile);
  }


  /// Wipes profile data only
  Future<void> resetProfile() async {
    final defaults = UserProfile.defaults();
    _profile = _profile.copyWith(
      name: defaults.name,
      age: defaults.age,
      weightGoal: defaults.weightGoal,
    );
    notifyListeners();
    await _repository.saveProfile(_profile);
  }


  Future<void> resetEverything() async {
    _profile = UserProfile.defaults();
    notifyListeners();
    await _repository.clearProfile();
  }
}
