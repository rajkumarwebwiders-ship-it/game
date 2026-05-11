import 'package:flutter/material.dart';

/// A utility class to show stylized, consistent SnackBar feedback.
/// 
/// Why use a custom SnackBar?
/// 1. **Visual Clarity**: Different colors and icons for different message types.
/// 2. **Consistency**: Ensure all feedback throughout the app looks identical.
/// 3. **Branding**: Allows for floating behavior and rounded designs that 
///    match the app's premium feel.
class CustomSnackBar {
  /// Shows a success SnackBar with a green theme and check icon.
  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message,
      backgroundColor: Colors.green.shade700,
      icon: Icons.check_circle_outline,
    );
  }

  /// Shows an error SnackBar with a red theme and error icon.
  static void showError(BuildContext context, String message) {
    _show(
      context,
      message,
      backgroundColor: Colors.red.shade700,
      icon: Icons.error_outline,
    );
  }

  static void _show(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
