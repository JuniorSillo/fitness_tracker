import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/featured_workout_banner.dart';
import '../widgets/workout_category_tile.dart';

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
    setState(() {
      _quote = 'The only bad workout is the one that didn\'t happen.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2DE394),
        title: const Text('FitTrack', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.white), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hello, Junior! 👋', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 4),
            const Text('Ready for today’s workout?', style: TextStyle(fontSize: 15, color: Colors.white70)),
            const SizedBox(height: 24),
            const FeaturedWorkoutBanner(),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2DE394),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.format_quote_rounded, color: Colors.white.withOpacity(0.4), size: 36),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _quote ?? 'Loading motivation...',
                      style: const TextStyle(color: Colors.white, fontSize: 15.5, fontStyle: FontStyle.italic, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('Workout Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
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
                    WorkoutCategoryTile(title: 'Cardio', icon: Icons.directions_run, color: Color(0xFF2DE394)),
                    WorkoutCategoryTile(title: 'Strength', icon: Icons.fitness_center, color: Color(0xFF366450)),
                    WorkoutCategoryTile(title: 'Flexibility', icon: Icons.self_improvement, color: Color(0xFF8DB3A3)),
                    WorkoutCategoryTile(title: 'HIIT', icon: Icons.timer, color: Color(0xFF2DE394)),
                  ],
                );
              },
            ),
            const SizedBox(height: 100), 
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          
        },
        backgroundColor: const Color(0xFF2DE394),
        icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
        label: const Text('Quick Start', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
