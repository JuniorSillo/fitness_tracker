class UserProfile {
  final String name;
  final int age;
  final double weightGoal;
  final String weightUnit;
  final int restTimerSeconds;
  final bool notificationsEnabled;

  const UserProfile({
    required this.name,
    required this.age,
    required this.weightGoal,
    required this.weightUnit,
    required this.restTimerSeconds,
    required this.notificationsEnabled,
  });


  factory UserProfile.defaults() => const UserProfile(
        name: 'Guest',
        age: 0,
        weightGoal: 0.0,
        weightUnit: 'kg',
        restTimerSeconds: 60,
        notificationsEnabled: true,
      );


  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final defaults = UserProfile.defaults();

    final rawUnit = json['weightUnit'] as String? ?? defaults.weightUnit;
    final weightUnit =
        (rawUnit == 'kg' || rawUnit == 'lbs') ? rawUnit : defaults.weightUnit;

    final rawTimer =
        (json['restTimerSeconds'] as num?)?.toInt() ?? defaults.restTimerSeconds;
    final restTimerSeconds = rawTimer.clamp(15, 300);

    final rawAge = (json['age'] as num?)?.toInt() ?? defaults.age;
    final age = (rawAge < 0 || rawAge > 120) ? defaults.age : rawAge;

    final rawGoal =
        (json['weightGoal'] as num?)?.toDouble() ?? defaults.weightGoal;
    final weightGoal = rawGoal < 0 ? defaults.weightGoal : rawGoal;

    return UserProfile(
      name: json['name'] as String? ?? defaults.name,
      age: age,
      weightGoal: weightGoal,
      weightUnit: weightUnit,
      restTimerSeconds: restTimerSeconds,
      notificationsEnabled:
          json['notificationsEnabled'] as bool? ?? defaults.notificationsEnabled,
    );
  }

  
  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'weightGoal': weightGoal,
        'weightUnit': weightUnit,
        'restTimerSeconds': restTimerSeconds,
        'notificationsEnabled': notificationsEnabled,
      };

  
  UserProfile copyWith({
    String? name,
    int? age,
    double? weightGoal,
    String? weightUnit,
    int? restTimerSeconds,
    bool? notificationsEnabled,
  }) =>
      UserProfile(
        name: name ?? this.name,
        age: age ?? this.age,
        weightGoal: weightGoal ?? this.weightGoal,
        weightUnit: weightUnit ?? this.weightUnit,
        restTimerSeconds: restTimerSeconds ?? this.restTimerSeconds,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      );
}
