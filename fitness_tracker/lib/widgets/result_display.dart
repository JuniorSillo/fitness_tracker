import 'package:flutter/material.dart';

class ResultDisplay extends StatelessWidget {
  final double? bmi;
  final String? category;

  const ResultDisplay({this.bmi, this.category, super.key});

  Color _getColor() {
    if (bmi == null) return Colors.grey;
    if (bmi! < 18.5) return Colors.blue;         // Underweight
    if (bmi! < 25)   return Colors.green;         // Normal
    if (bmi! < 30)   return Colors.orange;        // Overweight
    return Colors.red;                            // Obese
  }

  @override
  Widget build(BuildContext context) {
    if (bmi == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E).withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _getColor(), width: 2),
        boxShadow: [BoxShadow(color: _getColor().withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Column(
        children: [
          Text(
            'Your BMI: ${bmi!.toStringAsFixed(1)}',
            style: TextStyle(color: _getColor(), fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            category ?? '—',
            style: TextStyle(color: _getColor(), fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Icon(
            bmi! < 18.5 ? Icons.arrow_downward : bmi! < 25 ? Icons.check_circle : Icons.warning,
            color: _getColor(),
            size: 40,
          ),
        ],
      ),
    );
  }
}
