/// Handles odometer calculation from trip meter readings,
/// accounting for the 999.99 km rollover reset.
class OdometerCalculator {
  static const double tripMeterCycle = 1000.0;

  /// Calculates distance travelled between two trip meter readings.
  ///
  /// Rules:
  ///   current > last  → no rollover  → current - last
  ///   current == last → full cycle   → 1000
  ///   current < last  → rolled over  → (1000 - last) + current
  ///
  /// Examples:
  ///   last=100, current=300 → 200        (5000 → 5200)
  ///   last=800, current=900 → 100        (5000 → 5100)
  ///   last=800, current=300 → 500        (5000 → 5500: (1000-800)+300)
  ///   last=500, current=500 → 1000       (5000 → 6000: full cycle)
  static double distanceTravelled({
    required double lastTrip,
    required double currentTrip,
  }) {
    if (currentTrip > lastTrip) {
      return currentTrip - lastTrip;
    } else if (currentTrip == lastTrip) {
      return tripMeterCycle;
    } else {
      // Rolled over: distance from lastTrip to 1000, then 0 to currentTrip
      return (tripMeterCycle - lastTrip) + currentTrip;
    }
  }

  /// Returns the new odometer value, or null if any input is missing.
  static double? calculateOdometer({
    required double? lastOdometer,
    required double? lastTrip,
    required double? currentTrip,
  }) {
    if (lastOdometer == null || lastTrip == null || currentTrip == null) {
      return null;
    }
    return lastOdometer +
        distanceTravelled(lastTrip: lastTrip, currentTrip: currentTrip);
  }
}
