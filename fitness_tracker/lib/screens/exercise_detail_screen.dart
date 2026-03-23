import 'package:flutter/material.dart';
import '../app_router.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final ExerciseDetailArgs args;

  const ExerciseDetailScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final totalVolume = args.sets * args.reps * args.weight;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.exerciseName),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Muscle Group', args.muscleGroup),
            _buildInfoRow('Sets', '${args.sets}'),
            _buildInfoRow('Reps', '${args.reps}'),
            _buildInfoRow('Weight', '${args.weight.toStringAsFixed(1)} kg'),
            const Divider(height: 48, thickness: 1.5, color: Colors.white24),
            Center(
              child: Column(
                children: [
                  Text(
                    'Total Volume',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${totalVolume.toStringAsFixed(0)} kg',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: const Color(0xFF2DE394),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
