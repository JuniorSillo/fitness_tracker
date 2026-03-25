import 'package:flutter/foundation.dart';
import '../models/exercise.dart';

class RoutineProvider extends ChangeNotifier {
  final List<Exercise> _routine = [];

  // --- Getters ---

  List<Exercise> get routine => List.unmodifiable(_routine);

  int get exerciseCount => _routine.length;

  double get totalVolume =>
      _routine.fold(0.0, (sum, e) => sum + e.volume);

  int get totalSets =>
      _routine.fold(0, (sum, e) => sum + e.sets);

  bool isInRoutine(String id) => _routine.any((e) => e.id == id);

  Map<String, int> get muscleGroupBreakdown {
    final map = <String, int>{};
    for (final exercise in _routine) {
      map[exercise.muscleGroup] = (map[exercise.muscleGroup] ?? 0) + 1;
    }
    return map;
  }

  // --- Mutations ---

  void addExercise(Exercise exercise) {
    if (isInRoutine(exercise.id)) return;
    _routine.add(exercise);
    notifyListeners();
  }

  void removeExercise(String id) {
    _routine.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void clearRoutine() {
    _routine.clear();
    notifyListeners();
  }
}
