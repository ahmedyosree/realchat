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
      style: const TextStyle(color: AppColors.inputText),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.inputBg,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.inputHint),
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
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.inputBorder, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade700),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade700, width: 2),
        ),
      ),
      validator: validator,
    );
  }
}
