class Validators {
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? meetingLink(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Meeting link is required';
    }
    final cleanValue = value.trim();
    if (!cleanValue.startsWith('http://') && !cleanValue.startsWith('https://')) {
      return 'Enter a valid URL starting with http:// or https://';
    }
    return null;
  }

  static String? maxStudents(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Max students is required';
    }
    final parsed = int.tryParse(value.trim());
    if (parsed == null) {
      return 'Enter a valid number';
    }
    if (parsed <= 0) {
      return 'Must be greater than 0';
    }
    return null;
  }

  static String? duration(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Duration is required';
    }
    final regex = RegExp(r'^(\d+h\s*)?(\d+m)?$');
    if (!regex.hasMatch(value.trim())) {
      return 'Use format "1h 30m" or "45m"';
    }
    return null;
  }

  static String? price(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Price is required';
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null) {
      return 'Enter a valid price amount';
    }
    if (parsed < 0) {
      return 'Price cannot be negative';
    }
    return null;
  }
}
