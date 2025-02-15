import 'package:flutter/material.dart';
import '../app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isPassword;
  final String? Function(String?) validator;
  final bool? obscureText;
  final VoidCallback? onToggleObscure;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
    this.isPassword = false,
    this.obscureText,
    this.onToggleObscure,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? (obscureText ?? false) : false,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.accent),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            obscureText! ? Icons.visibility_off : Icons.visibility,
            color: AppColors.accent,
          ),
          onPressed: onToggleObscure,
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.button),
        ),
      ),
      validator: validator,
    );
  }
}