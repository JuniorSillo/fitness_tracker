import 'package:flutter/material.dart';
import 'widgets/input_card.dart';
import 'widgets/result_display.dart';
import 'widgets/custom_calculate_button.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  double? _bmi;
  String? _category;

  void _calculateBmi() {
    final heightText = _heightController.text.trim();
    final weightText = _weightController.text.trim();

    if (heightText.isEmpty || weightText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter height and weight')),
      );
      return;
    }

    final heightCm = double.tryParse(heightText);
    final weightKg = double.tryParse(weightText);

    if (heightCm == null || weightKg == null || heightCm <= 0 || weightKg <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid positive numbers')),
      );
      return;
    }

    final heightM = heightCm / 100;
    final bmi = weightKg / (heightM * heightM);

    String category;
    if (bmi < 18.5) category = 'Underweight';
    else if (bmi < 25) category = 'Normal Weight';
    else if (bmi < 30) category = 'Overweight';
    else category = 'Obese';

    setState(() {
      _bmi = bmi;
      _category = category;
    });
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2DE394),
        title: const Text('BMI Calculator', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Calculate Your BMI',
              style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter your height and weight below',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 32),
            InputCard(
              title: 'Height',
              hint: 'e.g. 175',
              icon: Icons.straighten,
              controller: _heightController,
              unit: 'cm',
            ),
            InputCard(
              title: 'Weight',
              hint: 'e.g. 70',
              icon: Icons.monitor_weight,
              controller: _weightController,
              unit: 'kg',
            ),
            const SizedBox(height: 32),
            CustomCalculateButton(onPressed: _calculateBmi),
            const SizedBox(height: 40),
            ResultDisplay(bmi: _bmi, category: _category),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
