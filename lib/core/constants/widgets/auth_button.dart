import 'package:flutter/material.dart';
import '../app_colors.dart';

class AuthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;

  const AuthButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color = AppColors.accent,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}