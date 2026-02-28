/// Utility class for validation
class ValidationUtils {
  ValidationUtils._();

  /// Validate email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'email est requis';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Email invalide';
    }

    return null;
  }

  /// Validate password
  static String? validatePassword(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }

    if (value.length < minLength) {
      return 'Le mot de passe doit contenir au moins $minLength caractères';
    }

    return null;
  }

  /// Validate phone number
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le numéro de téléphone est requis';
    }

    final digits = value.replaceAll(RegExp(r'\D'), '');

    if (digits.length != 10) {
      return 'Le numéro doit contenir 10 chiffres';
    }

    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName est requis';
    }
    return null;
  }

  /// Validate name
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le nom est requis';
    }

    if (value.trim().length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }

    return null;
  }

  /// Validate address
  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'L\'adresse est requise';
    }

    if (value.trim().length < 5) {
      return 'L\'adresse doit contenir au moins 5 caractères';
    }

    return null;
  }

  /// Validate quantity
  static String? validateQuantity(String? value, {int max = 99}) {
    if (value == null || value.isEmpty) {
      return 'La quantité est requise';
    }

    final quantity = int.tryParse(value);

    if (quantity == null) {
      return 'Quantité invalide';
    }

    if (quantity < 1) {
      return 'La quantité doit être au moins 1';
    }

    if (quantity > max) {
      return 'La quantité maximale est $max';
    }

    return null;
  }
}
