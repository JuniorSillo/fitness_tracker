import 'package:flutter/material.dart';

class CustomCalculateButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomCalculateButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      splashColor: Colors.white24,
      highlightColor: Colors.white12,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2DE394), Color(0xFF196745)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: const Color(0xFF2DE394).withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6)),
          ],
        ),
        child: const Center(
          child: Text(
            'CALCULATE BMI',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
