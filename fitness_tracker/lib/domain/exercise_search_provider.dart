import 'package:flutter/foundation.dart';
import '../data/exercise_api_repository.dart';
import '../data/models/api_exercise.dart';


class ExerciseSearchProvider extends ChangeNotifier {
  final ExerciseApiRepository _repository;

  ExerciseSearchProvider(this._repository);


  List<ApiExercise> _searchResults = [];
  bool              _isLoading     = false;
  String?           _errorMessage;

  // Stores the last set of filters so retry() can reuse them
  String? _lastMuscle;
  String? _lastType;
  String? _lastDifficulty;
  String? _lastName;

  // Public getters
  List<ApiExercise> get searchResults  => List.unmodifiable(_searchResults);
  bool              get isLoading      => _isLoading;
  String?           get errorMessage   => _errorMessage;
  bool              get hasResults     => _searchResults.isNotEmpty;
  bool              get hasError       => _errorMessage != null;

  /// True if the user has performed at least one search
  bool get hasSearched =>
      _lastMuscle != null ||
          _lastType != null ||
          _lastDifficulty != null ||
          _lastName != null;

  // Search


  Future<void> searchExercises({
    String? muscle,
    String? type,
    String? difficulty,
    String? name,
  }) async {

    final cleanMuscle     = muscle?.trim().toLowerCase();
    final cleanType       = type?.trim().toLowerCase();
    final cleanDifficulty = difficulty?.trim().toLowerCase();
    final cleanName       = name?.trim().toLowerCase();


    final hasInput = [cleanMuscle, cleanType, cleanDifficulty, cleanName]
        .any((v) => v != null && v.isNotEmpty);
    if (!hasInput) return;


    _lastMuscle     = cleanMuscle;
    _lastType       = cleanType;
    _lastDifficulty = cleanDifficulty;
    _lastName       = cleanName;


    _isLoading    = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _searchResults = await _repository.searchExercises(
        muscle:     cleanMuscle,
        type:       cleanType,
        difficulty: cleanDifficulty,
        name:       cleanName,
      );
    } catch (e) {

      _errorMessage  = e.toString().replaceFirst('Exception: ', '');
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> retry() => searchExercises(
    muscle:     _lastMuscle,
    type:       _lastType,
    difficulty: _lastDifficulty,
    name:       _lastName,
  );

  void clearResults() {
    _searchResults  = [];
    _isLoading      = false;
    _errorMessage   = null;
    _lastMuscle     = null;
    _lastType       = null;
    _lastDifficulty = null;
    _lastName       = null;
    notifyListeners();
  }
}