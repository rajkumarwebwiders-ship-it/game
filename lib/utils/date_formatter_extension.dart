import 'package:intl/intl.dart';

/// Extension on [DateTime] to provide easy access to common formatting tasks.
/// 
/// This follows senior developer practices by:
/// 1. **Centralizing Formatting**: Ensuring consistent date strings across the app.
/// 2. **Improving Readability**: Using expressive getters instead of utility calls.
extension DateTimeFormatter on DateTime {
  /// Returns the date formatted as 'yyyy-MM-dd' for database/storage.
  String get toGameDate => DateFormat('yyyy-MM-dd').format(this);

  /// Returns a user-friendly display date (e.g., 'May 11, 2024').
  String get toDisplayDate => DateFormat.yMMMMd().format(this);
}
