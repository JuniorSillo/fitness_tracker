import 'package:flutter/material.dart';

class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({super.key});

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();

  String? _selectedMuscleGroup;

  double? _totalVolume;

  final List<String> _muscleGroups = [
    'Chest',
    'Back',
    'Legs',
    'Arms',
    'Shoulders',
    'Core',
  ];

  @override
  void initState() {
    super.initState();
    _setsController.addListener(_updateVolume);
    _repsController.addListener(_updateVolume);
    _weightController.addListener(_updateVolume);
  }

  void _updateVolume() {
    final sets = int.tryParse(_setsController.text.trim());
    final reps = int.tryParse(_repsController.text.trim());
    final weight = double.tryParse(_weightController.text.trim());

    if (sets != null && reps != null && weight != null) {
      setState(() {
        _totalVolume = (sets * reps * weight).toDouble();
      });
    } else {
      setState(() {
        _totalVolume = null;
      });
    }
  }

  void _saveExercise() {
    if (_formKey.currentState!.validate()) {
      final exerciseData = {
        'name': _nameController.text.trim(),
        'sets': int.parse(_setsController.text.trim()),
        'reps': int.parse(_repsController.text.trim()),
        'weight': double.parse(_weightController.text.trim()),
        'muscleGroup': _selectedMuscleGroup,
      };

      Navigator.pop(context, exerciseData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Exercise added successfully!'),
          backgroundColor: Color(0xFF2DE394),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Custom Exercise'),
        backgroundColor: const Color(0xFF2DE394),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Exercise Name
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Exercise Name',
                  hintText: 'e.g. Dumbbell Bench Press',
                  prefixIcon: const Icon(Icons.fitness_center),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Exercise name is required';
                  }
                  if (value.trim().length < 3) {
                    return 'Name must be at least 3 characters';
                  }
                  if (value.trim().length > 50) {
                    return 'Name cannot exceed 50 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Sets
              TextFormField(
                controller: _setsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Sets',
                  hintText: 'e.g. 4',
                  prefixIcon: const Icon(Icons.format_list_numbered),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Number of sets is required';
                  }
                  final sets = int.tryParse(value.trim());
                  if (sets == null) {
                    return 'Sets must be a whole number';
                  }
                  if (sets <= 0) {
                    return 'Sets must be greater than zero';
                  }
                  if (sets > 20) {
                    return 'Sets cannot exceed 20';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Reps
              TextFormField(
                controller: _repsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Reps',
                  hintText: 'e.g. 10',
                  prefixIcon: const Icon(Icons.repeat),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Number of reps is required';
                  }
                  final reps = int.tryParse(value.trim());
                  if (reps == null) {
                    return 'Reps must be a whole number';
                  }
                  if (reps <= 0) {
                    return 'Reps must be greater than zero';
                  }
                  if (reps > 100) {
                    return 'Reps cannot exceed 100';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Weight
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Weight',
                  hintText: 'e.g. 60',
                  prefixIcon: const Icon(Icons.monitor_weight),
                  suffixText: 'kg',
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Weight is required';
                  }
                  final weight = double.tryParse(value.trim());
                  if (weight == null) {
                    return 'Weight must be a valid number';
                  }
                  if (weight < 0) {
                    return 'Weight cannot be negative';
                  }
                  if (weight > 500) {
                    return 'Weight cannot exceed 500kg';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Dropdown Muscle Group (Extra Credit)
              DropdownButtonFormField<String>(
                value: _selectedMuscleGroup,
                hint: const Text('Select Muscle Group...'),
                isExpanded: true,
                items: _muscleGroups
                    .map((group) => DropdownMenuItem(
                          value: group,
                          child: Text(group),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMuscleGroup = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Target Muscle Group',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a muscle group';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Real-time Volume Preview(Extra Credit)
              if (_totalVolume != null || _setsController.text.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF196745).withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF2DE394), width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calculate, color: Color(0xFF2DE394), size: 28),
                      const SizedBox(width: 12),
                      Text(
                        'Total Volume: ${_setsController.text.isEmpty ? "--" : _setsController.text} × '
                        '${_repsController.text.isEmpty ? "--" : _repsController.text} × '
                        '${_weightController.text.isEmpty ? "--" : _weightController.text} = '
                        '${_totalVolume != null ? _totalVolume!.toStringAsFixed(0) : "--"} kg',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 40),

              // Submit Button
              ElevatedButton.icon(
                onPressed: _saveExercise,
                icon: const Icon(Icons.save),
                label: const Text('Save Exercise', style: TextStyle(fontSize: 17)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2DE394),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
