import 'package:flutter/material.dart';
import 'package:fuelsense/domain/entities/refuel.dart';

class RefuelEntryTypeHelper {
  static Color getEntryTypeColor(RefuelEntryType type) {
    switch (type) {
      case RefuelEntryType.reserveIncomplete:
        return Colors.orange;
      case RefuelEntryType.reserveComplete:
        return Colors.green;
      case RefuelEntryType.topup:
        return Colors.blue;
    }
  }

  static IconData getEntryTypeIcon(RefuelEntryType type) {
    switch (type) {
      case RefuelEntryType.reserveIncomplete:
        return Icons.warning;
      case RefuelEntryType.reserveComplete:
        return Icons.local_gas_station;
      case RefuelEntryType.topup:
        return Icons.add;
    }
  }

  static String getEntryTypeLabel(RefuelEntryType type) {
    switch (type) {
      case RefuelEntryType.reserveIncomplete:
        return 'Reserve Hit';
      case RefuelEntryType.reserveComplete:
        return 'Refueled';
      case RefuelEntryType.topup:
        return 'Top-up';
    }
  }
}
