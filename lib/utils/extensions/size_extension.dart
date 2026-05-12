import 'package:flutter/material.dart';

/// Extension on [num] to simplify the creation of [SizedBox] for spacing.
/// 
/// Instead of:
/// const SizedBox(height: 16)
/// 
/// You can now use:
/// 16.height
extension SizeExtension on num {
  /// Returns a [SizedBox] with the specified height.
  Widget get height => SizedBox(height: toDouble());

  /// Returns a [SizedBox] with the specified width.
  Widget get width => SizedBox(width: toDouble());
}
