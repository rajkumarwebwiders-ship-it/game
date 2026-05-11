import 'package:flutter/material.dart';

/// A reusable text input field that inherits its styling from the global theme.
/// By removing internal styling, we ensure the app remains consistent and 
/// easy to re-theme from a single location (main.dart).
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool readOnly;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.onTap,
    this.readOnly = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        // Styling is now handled by the global InputDecorationTheme
      ),
      readOnly: readOnly,
      onTap: onTap,
      validator: validator ?? (value) => 
          value == null || value.isEmpty ? 'Enter $label' : null,
    );
  }
}
