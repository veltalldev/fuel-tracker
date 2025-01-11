import 'package:flutter/material.dart';

/// Validates odometer reading against business rules
class OdometerValidator {
  /// The previous odometer reading to validate against
  final double? previousReading;

  const OdometerValidator({
    this.previousReading,
  });

  /// Validates an odometer reading
  /// Returns null if valid, error message if invalid
  String? validate(String? value) {
    // Check if empty
    if (value == null || value.isEmpty) {
      return 'Odometer reading is required';
    }

    // Check if numeric
    final reading = double.tryParse(value);
    if (reading == null) {
      return 'Please enter a valid number';
    }

    // Check if positive
    if (reading <= 0) {
      return 'Odometer reading must be greater than 0';
    }

    // Check if greater than previous reading
    if (previousReading != null && reading <= previousReading!) {
      return 'Reading must be greater than previous (${previousReading!.toStringAsFixed(1)})';
    }

    return null;
  }
}
