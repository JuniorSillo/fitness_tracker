import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/exercise_search_provider.dart';
import '../../data/models/api_exercise.dart';

class ExerciseSearchScreen extends StatefulWidget {
  const ExerciseSearchScreen({super.key});

  @override
  State<ExerciseSearchScreen> createState() => _ExerciseSearchScreenState();
}

class _ExerciseSearchScreenState extends State<ExerciseSearchScreen> {
  final _nameController = TextEditingController();
  Timer? _debounceTimer;


  String? _selectedMuscle;
  String? _selectedType;
  String? _selectedDifficulty;

  static const List<String> _muscles = [
    'abdominals', 'abductors', 'adductors', 'biceps', 'calves',
    'chest', 'forearms', 'glutes', 'hamstrings', 'lats',
    'lower_back', 'middle_back', 'neck', 'quadriceps',
    'traps', 'triceps',
  ];

  static const List<String> _types = [
    'cardio', 'olympic_weightlifting', 'plyometrics',
    'powerlifting', 'strength', 'stretching', 'strongman',
  ];

  static const List<String> _difficulties = [
    'beginner', 'intermediate', 'expert',
  ];

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _nameController.dispose();
    super.dispose();
  }

  // Search trigger

  void _triggerSearch() {
    context.read<ExerciseSearchProvider>().searchExercises(
      muscle:     _selectedMuscle,
      type:       _selectedType,
      difficulty: _selectedDifficulty,
      name:       _nameController.text.trim().isEmpty
          ? null
          : _nameController.text.trim(),
    );
  }


  void _onNameChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {

      final hasFilter = _selectedMuscle != null ||
          _selectedType != null ||
          _selectedDifficulty != null ||
          value.trim().isNotEmpty;
      if (hasFilter) _triggerSearch();
    });
  }

  // Helpers

  Color _difficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'expert':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatLabel(String raw) =>
      raw.isEmpty ? '' : raw.replaceAll('_', ' ').split(' ').map((w) =>
      '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

  //  Build

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Exercise Search',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF196745),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchPanel(),
          const Divider(color: Colors.white24, height: 1),
          Expanded(child: _buildResultsArea()),
        ],
      ),
    );
  }

  // Search panel

  Widget _buildSearchPanel() {
    return Consumer<ExerciseSearchProvider>(
      builder: (context, provider, _) {
        final isLoading = provider.isLoading;

        return Container(
          color: const Color(0xFF0D2B1F),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                onChanged: _onNameChanged,
                onSubmitted: (_) => isLoading ? null : _triggerSearch(),
                decoration: InputDecoration(
                  hintText: 'Search by name (e.g. curl, press, squat)',
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF2DE394)),
                  suffixIcon: _nameController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white54),
                    onPressed: () {
                      _nameController.clear();
                      setState(() {});
                    },
                  )
                      : null,
                  filled: true,
                  fillColor: const Color(0xFF196745),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2DE394)),
                  ),
                ),
              ),
              const SizedBox(height: 12),


              Row(
                children: [
                  Expanded(child: _buildDropdown(
                    label: 'Muscle',
                    value: _selectedMuscle,
                    items: _muscles,
                    onChanged: isLoading ? null : (val) {
                      setState(() => _selectedMuscle = val);
                    },
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: _buildDropdown(
                    label: 'Type',
                    value: _selectedType,
                    items: _types,
                    onChanged: isLoading ? null : (val) {
                      setState(() => _selectedType = val);
                    },
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: _buildDropdown(
                    label: 'Level',
                    value: _selectedDifficulty,
                    items: _difficulties,
                    onChanged: isLoading ? null : (val) {
                      setState(() => _selectedDifficulty = val);
                    },
                  )),
                ],
              ),
              const SizedBox(height: 12),


              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(

                  onPressed: isLoading ? null : _triggerSearch,
                  icon: isLoading
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  )
                      : const Icon(Icons.search_rounded),
                  label: Text(
                    isLoading ? 'Searching...' : 'Search Exercises',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2DE394),
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.white24,
                    disabledForegroundColor: Colors.white38,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?)? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF196745),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF196745),
          hint: Text(label,
              style: const TextStyle(color: Colors.white54, fontSize: 13)),
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF2DE394)),
          style: const TextStyle(color: Colors.white, fontSize: 13),
          onChanged: onChanged == null
              ? null
              : (val) {
            onChanged(val);
          },
          items: [

            DropdownMenuItem<String>(
              value: null,
              child: Text('Any $label',
                  style: const TextStyle(color: Colors.white54, fontSize: 13)),
            ),
            ...items.map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(_formatLabel(item),
                  style: const TextStyle(fontSize: 13)),
            )),
          ],
        ),
      ),
    );
  }

  // Results area

  Widget _buildResultsArea() {
    return Consumer<ExerciseSearchProvider>(
      builder: (context, provider, _) {

        if (provider.isLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFF2DE394)),
                SizedBox(height: 16),
                Text('Fetching exercises...',
                    style: TextStyle(color: Colors.white60)),
              ],
            ),
          );
        }

        // Error state
        if (provider.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off_rounded,
                      size: 72, color: Colors.white24),
                  const SizedBox(height: 16),
                  Text(
                    provider.errorMessage ?? 'Something went wrong.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton.icon(
                    onPressed: () => provider.retry(),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Tap to Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2DE394),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Success state
        if (provider.hasResults) {
          return Column(
            children: [
              // Result count header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                color: const Color(0xFF196745).withValues(alpha: 0.5),
                child: Text(
                  '${provider.searchResults.length} exercise${provider.searchResults.length == 1 ? '' : 's'} found',
                  style: const TextStyle(
                      color: Color(0xFF2DE394),
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: provider.searchResults.length,
                  itemBuilder: (context, index) {
                    return _buildExerciseCard(
                        provider.searchResults[index]);
                  },
                ),
              ),
            ],
          );
        }


        if (provider.hasSearched) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off_rounded,
                      size: 72, color: Colors.white24),
                  const SizedBox(height: 16),
                  const Text(
                    'No exercises found.',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Try a different muscle group,\ntype, or difficulty level.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white60, fontSize: 15),
                  ),
                ],
              ),
            ),
          );
        }

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.fitness_center_rounded,
                    size: 80, color: Color(0xFF196745)),
                const SizedBox(height: 20),
                const Text(
                  'Find Any Exercise',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Search by muscle group, type, difficulty,\nor exercise name above.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white60, fontSize: 15, height: 1.5),
                ),
                const SizedBox(height: 24),


                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: ['biceps', 'chest', 'quadriceps', 'hamstrings', 'lats']
                      .map((muscle) => ActionChip(
                    label: Text(_formatLabel(muscle)),
                    backgroundColor: const Color(0xFF196745),
                    labelStyle: const TextStyle(color: Color(0xFF2DE394)),
                    side: const BorderSide(color: Color(0xFF2DE394)),
                    onPressed: () {
                      setState(() => _selectedMuscle = muscle);
                      context
                          .read<ExerciseSearchProvider>()
                          .searchExercises(muscle: muscle);
                    },
                  ))
                      .toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Exercise card

  Widget _buildExerciseCard(ApiExercise exercise) {
    return Card(
      color: const Color(0xFF196745),
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding:
        const EdgeInsets.fromLTRB(16, 0, 16, 16),
        iconColor: const Color(0xFF2DE394),
        collapsedIconColor: Colors.white54,
        title: Text(
          exercise.name,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 4),
          child: Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              // Muscle chip
              if (exercise.muscle.isNotEmpty)
                _chip(
                  label: exercise.muscleLabel,
                  icon: Icons.sports_gymnastics,
                  color: const Color(0xFF2DE394),
                ),
              // Difficulty chip
              if (exercise.difficulty.isNotEmpty)
                _chip(
                  label: exercise.difficultyLabel,
                  icon: Icons.signal_cellular_alt,
                  color: _difficultyColor(exercise.difficulty),
                ),
              // Type chip
              if (exercise.type.isNotEmpty)
                _chip(
                  label: _formatLabel(exercise.type),
                  icon: Icons.category_outlined,
                  color: Colors.blueGrey,
                ),
            ],
          ),
        ),
        children: [
          // Equipment
          if (exercise.equipment.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(Icons.build_outlined,
                      size: 16, color: Colors.white54),
                  const SizedBox(width: 6),
                  Text(
                    'Equipment: ${_formatLabel(exercise.equipment)}',
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

          // Instructions
          const Text(
            'Instructions',
            style: TextStyle(
                color: Color(0xFF2DE394),
                fontWeight: FontWeight.bold,
                fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            exercise.instructions.isEmpty
                ? 'No instructions available.'
                : exercise.instructions,
            style: const TextStyle(
                color: Colors.white70, fontSize: 13, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _chip({
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}