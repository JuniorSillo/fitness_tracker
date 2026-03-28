import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/featured_workout_banner.dart';
import '../widgets/workout_category_tile.dart';
import '../../domain/routine_provider.dart';
import '../../domain/profile_provider.dart';
import '../app_router.dart';
import 'exercise_browse_screen.dart';
import 'routine_summary_screen.dart';
import 'settings_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _quote;

  @override
  void initState() {
    super.initState();
    _loadQuote();
  }

  Future<void> _loadQuote() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _quote = "The only bad workout is the one that didn't happen.";
      });
    }
  }

  Future<void> _addExercise() async {
    final result =
        await Navigator.of(context).pushRoute(AppRoute.addExercise);
    if (result != null && result is Map<String, dynamic> && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added: ${result['name']}'),
          backgroundColor: const Color(0xFF2DE394),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final routineCount = context.watch<RoutineProvider>().exerciseCount;
    final profile = context.watch<ProfileProvider>();

    final greeting =
        (profile.name.isEmpty || profile.name == 'Guest')
            ? 'Welcome! 👋'
            : 'Welcome back, ${profile.name}! 👋';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2DE394),
        title: const Text('FitTrack',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22)),
        centerTitle: true,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.list_alt_rounded, color: Colors.white),
                tooltip: 'My Routine',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const RoutineSummaryScreen()),
                ),
              ),
              if (routineCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: Text('$routineCount',
                        style: const TextStyle(
                            color: Color(0xFF196745),
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded, color: Colors.white),
            tooltip: 'Profile & Settings',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const SettingsProfileScreen()),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(greeting,
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 4),

            if (profile.weightGoal > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Chip(
                  avatar: const Icon(Icons.flag_rounded,
                      color: Colors.black, size: 16),
                  label: Text(
                    'Goal: ${profile.weightGoal.toStringAsFixed(1)} ${profile.weightUnit}',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  backgroundColor: const Color(0xFF2DE394),
                  padding: EdgeInsets.zero,
                ),
              ),

            const Text("Ready for today's workout?",
                style: TextStyle(fontSize: 15, color: Colors.white70)),
            const SizedBox(height: 24),
            const FeaturedWorkoutBanner(),
            const SizedBox(height: 32),

            // Quote card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2DE394),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.format_quote_rounded,
                      color: Colors.white.withValues(alpha: 0.4), size: 36),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _quote ?? 'Loading motivation...',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15.5,
                          fontStyle: FontStyle.italic,
                          height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _navCard(
              icon: Icons.search_rounded,
              title: 'Browse Exercises',
              subtitle: 'Add exercises to your daily routine',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ExerciseBrowseScreen()),
              ),
            ),
            const SizedBox(height: 12),

            _navCard(
              icon: Icons.calculate_outlined,
              title: 'BMI Calculator',
              subtitle: 'Check your Body Mass Index',
              onTap: () => Navigator.of(context).pushRoute(AppRoute.bmi),
            ),

            const SizedBox(height: 32),

            const Text('Workout Categories',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 16),

            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 2;
                if (constraints.maxWidth > 600) crossAxisCount = 3;
                if (constraints.maxWidth > 900) crossAxisCount = 4;
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: const [
                    WorkoutCategoryTile(
                        title: 'Cardio',
                        icon: Icons.directions_run,
                        color: Color(0xFFE53935)),
                    WorkoutCategoryTile(
                        title: 'Strength',
                        icon: Icons.fitness_center,
                        color: Color(0xFF1E88E5)),
                    WorkoutCategoryTile(
                        title: 'Flexibility',
                        icon: Icons.self_improvement,
                        color: Color(0xFF2DE394)),
                    WorkoutCategoryTile(
                        title: 'HIIT',
                        icon: Icons.timer,
                        color: Color(0xFFFB8C00)),
                  ],
                );
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addExercise,
        backgroundColor: const Color(0xFF2DE394),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Exercise',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _navCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF196745),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF2DE394), size: 36),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white54, size: 20),
          ],
        ),
      ),
    );
  }
}
