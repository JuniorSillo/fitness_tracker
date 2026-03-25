import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/routine_provider.dart';
import 'exercise_browse_screen.dart';

class RoutineSummaryScreen extends StatelessWidget {
  const RoutineSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RoutineProvider>();
    final routine = provider.routine;
    final breakdown = provider.muscleGroupBreakdown;
    final maxCount =
        breakdown.isEmpty ? 1 : breakdown.values.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Routine',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF196745),
        centerTitle: true,
        actions: [
          if (routine.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded, color: Colors.white),
              tooltip: 'Clear Routine',
              onPressed: () => _confirmClear(context),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: routine.isEmpty ? _buildEmptyState(context) : _buildContent(context, provider, routine, breakdown, maxCount),
    );
  }

  // ── Empty state ──────────────────────────────────────────────────────────────
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.fitness_center, size: 80, color: Color(0xFF196745)),
          const SizedBox(height: 20),
          const Text(
            'Your routine is empty',
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Browse exercises and add them\nto build your daily routine',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white60, fontSize: 15),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ExerciseBrowseScreen()),
            ),
            icon: const Icon(Icons.search),
            label: const Text('Browse Exercises'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2DE394),
              foregroundColor: Colors.black,
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Main content ─────────────────────────────────────────────────────────────
  Widget _buildContent(
    BuildContext context,
    RoutineProvider provider,
    exercises,
    Map<String, int> breakdown,
    int maxCount,
  ) {
    return Column(
      children: [
        // Stats header
        _buildStatsHeader(provider),

        // Muscle group breakdown
        _buildBreakdown(breakdown, maxCount),

        const Divider(color: Colors.white24, height: 1),

        // Exercise list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final ex = exercises[index];
              return Dismissible(
                key: Key(ex.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.delete_rounded,
                      color: Colors.white, size: 28),
                ),
                onDismissed: (_) {
                  context.read<RoutineProvider>().removeExercise(ex.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${ex.name} removed'),
                      backgroundColor: Colors.redAccent,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF196745),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF0D2B1F),
                      child: Icon(Icons.fitness_center,
                          color: Color(0xFF2DE394), size: 20),
                    ),
                    title: Text(ex.name,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      '${ex.muscleGroup}  •  ${ex.sets} × ${ex.reps} @ ${ex.weight == 0 ? 'BW' : '${ex.weight}kg'}',
                      style: const TextStyle(color: Colors.white60),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${ex.volume.toStringAsFixed(0)} kg',
                          style: const TextStyle(
                              color: Color(0xFF2DE394),
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        const Text('volume',
                            style:
                                TextStyle(color: Colors.white38, fontSize: 11)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Stats header ─────────────────────────────────────────────────────────────
  Widget _buildStatsHeader(RoutineProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      color: const Color(0xFF0D2B1F),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statChip(Icons.list_rounded, '${provider.exerciseCount}', 'Exercises'),
          _statChip(Icons.repeat_rounded, '${provider.totalSets}', 'Total Sets'),
          _statChip(Icons.monitor_weight_rounded,
              '${provider.totalVolume.toStringAsFixed(0)}kg', 'Total Volume'),
        ],
      ),
    );
  }

  Widget _statChip(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF2DE394), size: 22),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

  // ── Muscle group breakdown ────────────────────────────────────────────────────
  Widget _buildBreakdown(Map<String, int> breakdown, int maxCount) {
    if (breakdown.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      color: const Color(0xFF0D2B1F),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Muscle Balance',
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5)),
          const SizedBox(height: 10),
          ...breakdown.entries.map((entry) {
            final fraction = entry.value / maxCount;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(entry.key,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13)),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: fraction,
                          child: Container(
                            height: 10,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2DE394),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('${entry.value}',
                      style: const TextStyle(
                          color: Color(0xFF2DE394),
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Clear confirmation dialog ─────────────────────────────────────────────────
  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF196745),
        title: const Text('Clear Routine',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          'Are you sure you want to remove all exercises from your routine? This cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              context.read<RoutineProvider>().clearRoutine();
              Navigator.pop(ctx);
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
