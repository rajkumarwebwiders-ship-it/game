import 'package:flutter/material.dart';

/// A reusable dropdown field that inherits its styling from the global theme.
class CustomDropdownField extends StatelessWidget {
  final String? value;
  final String label;
  final IconData icon;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const CustomDropdownField({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        // Styling is now handled by the global InputDecorationTheme
      ),
      items: items.map((item) => DropdownMenuItem(
        value: item, 
        child: Text(item)
      )).toList(),
      onChanged: onChanged,
      validator: validator ?? (val) => 
          val == null ? 'Select $label' : null,
    );
  }
}
