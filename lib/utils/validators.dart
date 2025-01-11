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

/// Validates numeric input fields with customizable rules
class NumericValidator {
  /// Minimum allowed value (inclusive)
  final double? min;

  /// Maximum allowed value (inclusive)
  final double? max;

  /// Whether to allow zero as a valid value
  final bool allowZero;

  /// Field name for error messages
  final String fieldName;

  const NumericValidator({
    this.min,
    this.max,
    this.allowZero = false,
    required this.fieldName,
  });

  /// Validates a numeric value
  /// Returns null if valid, error message if invalid
  String? validate(String? value) {
    // Check if empty
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    // Check if numeric
    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }

    // Check if non-negative
    if (!allowZero && number <= 0) {
      return '$fieldName must be greater than 0';
    }

    // Check if zero is allowed
    if (!allowZero && number == 0) {
      return '$fieldName cannot be zero';
    }

    // Check minimum value
    if (min != null && number < min!) {
      return '$fieldName must be at least ${min!.toStringAsFixed(1)}';
    }

    // Check maximum value
    if (max != null && number > max!) {
      return '$fieldName must be no more than ${max!.toStringAsFixed(1)}';
    }

    return null;
  }
}

// Common validator instances
const volumeValidator = NumericValidator(
  fieldName: 'Fuel volume',
  min: 0.1,
);

const priceValidator = NumericValidator(
  fieldName: 'Price',
  min: 0.01,
);
