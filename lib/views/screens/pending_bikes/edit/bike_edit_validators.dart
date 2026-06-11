class AddBikeValidators {
  static String? validateBrand(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter brand';
    }
    return null;
  }

  static String? validateModel(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter model';
    }
    return null;
  }

  static String? validateEngineCC(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter engine CC';
    }
    if (int.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  static String? validateModelYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter model year';
    }
    final year = int.tryParse(value);
    if (year == null) {
      return 'Please enter a valid year';
    }
    if (year < 1900 || year > DateTime.now().year + 1) {
      return 'Please enter a valid year';
    }
    return null;
  }

  static String? validateExpectedMileage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter expected mileage';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  static String? validateTankCapacity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter tank capacity';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  static String? validateReserveCapacity(String? value) {
    if (value != null && value.isNotEmpty) {
      if (double.tryParse(value) == null) {
        return 'Please enter a valid number';
      }
    }
    return null;
  }
}
