abstract final class AppValidators {
  static final _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final _phone = RegExp(r'^\+?[0-9]{7,15}$');

  static String? required(String? value, String message) =>
      value == null || value.trim().isEmpty ? message : null;

  static String? email(
    String? value, {
    required String requiredMessage,
    required String invalidMessage,
  }) {
    final missing = required(value, requiredMessage);
    if (missing != null) return missing;
    return _email.hasMatch(value!.trim()) ? null : invalidMessage;
  }

  static String? phone(
    String? value, {
    required String requiredMessage,
    required String invalidMessage,
  }) {
    final missing = required(value, requiredMessage);
    if (missing != null) return missing;
    final normalized = value!.replaceAll(RegExp(r'[\s()-]'), '');
    return _phone.hasMatch(normalized) ? null : invalidMessage;
  }

  static String? password(
    String? value, {
    required String requiredMessage,
    required String invalidMessage,
    int minimumLength = 8,
  }) {
    final missing = required(value, requiredMessage);
    if (missing != null) return missing;
    return value!.length >= minimumLength ? null : invalidMessage;
  }
}
