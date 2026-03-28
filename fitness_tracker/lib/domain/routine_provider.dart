import 'package:flutter/foundation.dart';
import '../data/routine_repository.dart';
import '../models/exercise.dart';


class RoutineProvider extends ChangeNotifier {
  final RoutineRepository _repository;

  List<Exercise> _routine = [];

  RoutineProvider(this._repository) {
    _init();
  }

  //  Getters 
  List<Exercise> get routine => List.unmodifiable(_routine);
  int            get exerciseCount => _routine.length;
  double         get totalVolume =>
      _routine.fold(0.0, (sum, e) => sum + e.volume);
  int            get totalSets =>
      _routine.fold(0, (sum, e) => sum + e.sets);

  bool isInRoutine(String id) => _routine.any((e) => e.id == id);

  Map<String, int> get muscleGroupBreakdown {
    final map = <String, int>{};
    for (final e in _routine) {
      map[e.muscleGroup] = (map[e.muscleGroup] ?? 0) + 1;
    }
    return map;
  }

  // Init 
  Future<void> _init() async {
    _routine = await _repository.loadRoutine();
    notifyListeners();
  }

  // Mutations 
  Future<void> addExercise(Exercise exercise) async {
    if (isInRoutine(exercise.id)) return;
    _routine.add(exercise);
    notifyListeners();
    await _repository.saveRoutine(_routine);
  }

  Future<void> removeExercise(String id) async {
    _routine.removeWhere((e) => e.id == id);
    notifyListeners();
    await _repository.saveRoutine(_routine);
  }

  Future<void> clearRoutine() async {
    _routine.clear();
    notifyListeners();
    await _repository.clearRoutine();
  }
}
