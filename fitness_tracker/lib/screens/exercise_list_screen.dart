import 'package:flutter/material.dart';
import '../app_router.dart';

class ExerciseListScreen extends StatelessWidget {
  final ExerciseListArgs args;

  const ExerciseListScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    // Calculate readable foreground color based on background brightness
    final brightness = ThemeData.estimateBrightnessForColor(args.themeColor);
    final foregroundColor = brightness == Brightness.dark ? Colors.white : Colors.black;

    // Example exercises 
    final exercises = [
      {'name': 'Running', 'muscleGroup': 'Legs', 'sets': 0, 'reps': 30, 'weight': 0.0},
      {'name': 'Cycling', 'muscleGroup': 'Legs', 'sets': 0, 'reps': 45, 'weight': 0.0},
      {'name': 'Jump Rope', 'muscleGroup': 'Full Body', 'sets': 5, 'reps': 100, 'weight': 0.0},
      {'name': 'Rowing Machine', 'muscleGroup': 'Back & Arms', 'sets': 4, 'reps': 500, 'weight': 0.0},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('${args.categoryName} Exercises'),
        backgroundColor: args.themeColor,
        foregroundColor: foregroundColor,
        leading: Icon(args.iconData),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final ex = exercises[index];
          return Card(
            color: const Color(0xFF196745),
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.fitness_center, color: Color(0xFF2DE394)),
              title: Text(
                ex['name'] as String,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '${ex['muscleGroup']} • ${ex['sets']} sets × ${ex['reps']} reps',
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 16),
              onTap: () {
                Navigator.of(context).pushRouteWithArgs(
                  AppRoute.exerciseDetail,
                  ExerciseDetailArgs(
                    exerciseName: ex['name'] as String,
                    muscleGroup: ex['muscleGroup'] as String,
                    sets: ex['sets'] as int,
                    reps: ex['reps'] as int,
                    weight: ex['weight'] as double,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
