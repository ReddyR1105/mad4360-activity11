String? validateName(String? value) =>
    value == null || value.trim().isEmpty ? 'Enter your full name' : null;
String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) return 'Enter your email address';
  return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value.trim())
      ? null
      : 'Enter a valid email address';
}

String? validatePassword(String? value) =>
    value == null || value.length < 6 ? 'Use at least 6 characters' : null;
