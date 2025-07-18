
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../app_colors.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleSignInButton({ super.key, required this.onPressed });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(10),
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: const FaIcon(
            FontAwesomeIcons.google,
            color: AppColors.googleIcon,
            size: 20,
          ),
          label: const Text(
            'Sign in with Google',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: BorderSide(color: AppColors.divider, width: 1.2),
          ),
        ),
      ),
    );
  }
}
