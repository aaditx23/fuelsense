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
        return Icons.warning_amber_rounded;
      case RefuelEntryType.reserveComplete:
        return Icons.local_gas_station_rounded;
      case RefuelEntryType.topup:
        return Icons.water_drop_rounded;
    }
  }

  static String getEntryTypeLabel(RefuelEntryType type) {
    switch (type) {
      case RefuelEntryType.reserveIncomplete:
        return 'Reserve Hit';
      case RefuelEntryType.reserveComplete:
        return 'Refuel';
      case RefuelEntryType.topup:
        return 'Top-up';
    }
  }
}
