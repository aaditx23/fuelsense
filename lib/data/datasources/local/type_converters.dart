import 'package:floor/floor.dart';

class DateTimeConverter extends TypeConverter<DateTime, String> {
  @override
  DateTime decode(String databaseValue) {
    return DateTime.parse(databaseValue);
  }

  @override
  String encode(DateTime value) {
    return value.toIso8601String();
  }
}

class NullableDateTimeConverter extends TypeConverter<DateTime?, String?> {
  @override
  DateTime? decode(String? databaseValue) {
    return databaseValue != null ? DateTime.parse(databaseValue) : null;
  }

  @override
  String? encode(DateTime? value) {
    return value?.toIso8601String();
  }
}
