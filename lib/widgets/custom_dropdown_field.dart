import 'package:flutter/material.dart';

/// [CustomDropdownField] is a stylized, reusable dropdown component.
class CustomDropdownField extends StatelessWidget {
  final String? value; // currently selected value
  final String label; // dropdown label text
  final IconData icon; // prefix icon
  final List<String> items; // list of options for the dropdown
  final ValueChanged<String?> onChanged; // callback when value changes
  final bool isLoading; // indicates if the data is still being fetched

  const CustomDropdownField({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.items,
    required this.onChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      items: isLoading
          ? [
              DropdownMenuItem(
                enabled: false,
                value: null,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Loading $label...',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ]
          : items.map((item) {
              return DropdownMenuItem(value: item, child: Text(item));
            }).toList(),
      onChanged: isLoading ? null : onChanged,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Please select a $label';
        }
        return null;
      },
    );
  }
}
