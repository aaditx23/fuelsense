/// Formats a double to up to 3 decimal places, trimming trailing zeros.
/// e.g. 5.0 → "5", 5.5 → "5.5", 5.123 → "5.123", 5.1234 → "5.123"
String formatDecimal(double value) {
  final s = value.toStringAsFixed(3);
  // Remove trailing zeros after the decimal point, then the dot itself if empty
  if (s.contains('.')) {
    String trimmed = s.replaceAll(RegExp(r'0+$'), '');
    if (trimmed.endsWith('.'))
      trimmed = trimmed.substring(0, trimmed.length - 1);
    return trimmed;
  }
  return s;
}
