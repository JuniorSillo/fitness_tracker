import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise.dart';
import '../providers/routine_provider.dart';
import 'routine_summary_screen.dart';

// Hardcoded catalogue of exercises across 4 muscle groups
final List<Exercise> _catalogue = [
  Exercise(id: '1',  name: 'Bench Press',     muscleGroup: 'Chest',    sets: 4, reps: 10, weight: 60.0),
  Exercise(id: '2',  name: 'Push-Ups',         muscleGroup: 'Chest',    sets: 3, reps: 15, weight: 0.0),
  Exercise(id: '3',  name: 'Incline Dumbbell', muscleGroup: 'Chest',    sets: 3, reps: 12, weight: 20.0),
  Exercise(id: '4',  name: 'Pull-Ups',         muscleGroup: 'Back',     sets: 4, reps: 8,  weight: 0.0),
  Exercise(id: '5',  name: 'Bent-Over Row',    muscleGroup: 'Back',     sets: 3, reps: 10, weight: 50.0),
  Exercise(id: '6',  name: 'Lat Pulldown',     muscleGroup: 'Back',     sets: 3, reps: 12, weight: 45.0),
  Exercise(id: '7',  name: 'Squats',           muscleGroup: 'Legs',     sets: 4, reps: 10, weight: 80.0),
  Exercise(id: '8',  name: 'Lunges',           muscleGroup: 'Legs',     sets: 3, reps: 12, weight: 20.0),
  Exercise(id: '9',  name: 'Leg Press',        muscleGroup: 'Legs',     sets: 3, reps: 15, weight: 100.0),
  Exercise(id: '10', name: 'Bicep Curl',       muscleGroup: 'Arms',     sets: 3, reps: 12, weight: 15.0),
  Exercise(id: '11', name: 'Tricep Dips',      muscleGroup: 'Arms',     sets: 3, reps: 10, weight: 0.0),
];

class ExerciseBrowseScreen extends StatelessWidget {
  const ExerciseBrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // watch — rebuilds when provider changes so indicators update reactively
    final provider = context.watch<RoutineProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Exercises',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF196745),
        centerTitle: true,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.list_alt_rounded, color: Colors.white),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const RoutineSummaryScreen()),
                ),
              ),
              if (provider.exerciseCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2DE394),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${provider.exerciseCount}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _catalogue.length,
        itemBuilder: (context, index) {
          final exercise = _catalogue[index];
          final isAdded = provider.isInRoutine(exercise.id);

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isAdded
                  ? const Color(0xFF2DE394).withValues(alpha: 0.15)
                  : const Color(0xFF196745),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isAdded
                    ? const Color(0xFF2DE394)
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: isAdded
                    ? const Color(0xFF2DE394)
                    : const Color(0xFF0D2B1F),
                child: Icon(
                  isAdded ? Icons.check : Icons.fitness_center,
                  color: isAdded ? Colors.black : const Color(0xFF2DE394),
                  size: 20,
                ),
              ),
              title: Text(
                exercise.name,
                style: TextStyle(
                  color: isAdded ? const Color(0xFF2DE394) : Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                '${exercise.muscleGroup}  •  ${exercise.sets} sets × ${exercise.reps} reps  •  ${exercise.weight == 0 ? 'Bodyweight' : '${exercise.weight}kg'}',
                style: const TextStyle(color: Colors.white60, fontSize: 13),
              ),
              trailing: isAdded
                  ? const Chip(
                      label: Text('Added',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                      backgroundColor: Color(0xFF2DE394),
                      padding: EdgeInsets.zero,
                    )
                  : IconButton(
                      icon: const Icon(Icons.add_circle_outline,
                          color: Color(0xFF2DE394), size: 28),
                      onPressed: () {
                        
                        context.read<RoutineProvider>().addExercise(exercise);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${exercise.name} added to routine'),
                            backgroundColor: const Color(0xFF2DE394),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }
}
