/// Validation logic for trip meter and odometer fields.
/// Kept separate to avoid cluttering widget files.
class MeterReadingValidator {
  /// Returns an error string if the trip meter value is invalid, otherwise null.
  static String? validateTripMeter({
    required String? value,
    required bool isFirstEntry,
    required double? currentOdometer,
  }) {
    final trimmed = value?.trim() ?? '';
    final isEmpty = trimmed.isEmpty;

    // First entry: both are mandatory
    if (isFirstEntry && isEmpty) {
      return 'Required for first entry';
    }

    // Not first entry: at least one must be filled
    if (!isFirstEntry && isEmpty && currentOdometer == null) {
      return 'Enter trip meter or odometer';
    }

    if (!isEmpty) {
      final parsed = double.tryParse(trimmed);
      if (parsed == null) return 'Enter a valid number';
      if (parsed <= 0) return 'Must be greater than 0';
      if (parsed > 999.99) return 'Cannot exceed 999.99 km';
    }

    return null;
  }

  /// Returns an error string if the odometer value is invalid, otherwise null.
  static String? validateOdometer({
    required String? value,
    required bool isFirstEntry,
    required double? currentTripMeter,
    required double? lastOdometerReading,
  }) {
    final trimmed = value?.trim() ?? '';
    final isEmpty = trimmed.isEmpty;

    // First entry: both are mandatory
    if (isFirstEntry && isEmpty) {
      return 'Required for first entry';
    }

    // Not first entry: at least one must be filled
    if (!isFirstEntry && isEmpty && currentTripMeter == null) {
      return 'Enter odometer or trip meter';
    }

    if (!isEmpty) {
      final parsed = double.tryParse(trimmed);
      if (parsed == null) return 'Enter a valid number';
      if (parsed <= 0) return 'Must be greater than 0';
      if (lastOdometerReading != null && parsed < lastOdometerReading) {
        return 'Cannot be less than last reading (${lastOdometerReading.toStringAsFixed(1)} km)';
      }
    }

    return null;
  }
}
