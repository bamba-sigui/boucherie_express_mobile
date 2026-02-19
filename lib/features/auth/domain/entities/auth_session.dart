import 'package:equatable/equatable.dart';

/// Session d'authentification par téléphone.
///
/// Contient les règles métier : validation téléphone, état OTP,
/// cooldown de renvoi, expiration.
class AuthSession extends Equatable {
  final String phone;
  final DateTime? otpRequestedAt;
  final bool isVerified;

  /// Longueur du code OTP.
  static const int otpLength = 4;

  /// Cooldown de renvoi en secondes.
  static const int resendCooldownSeconds = 45;

  /// Expiration OTP en minutes.
  static const int otpExpiryMinutes = 5;

  const AuthSession({
    required this.phone,
    this.otpRequestedAt,
    this.isVerified = false,
  });

  // ── Business rules ────────────────────────────────────────────────────

  /// `true` si le délai de renvoi est écoulé.
  bool canResendOtp() {
    if (otpRequestedAt == null) return true;
    final elapsed = DateTime.now().difference(otpRequestedAt!).inSeconds;
    return elapsed >= resendCooldownSeconds;
  }

  /// `true` si le code OTP a expiré.
  bool isOtpExpired() {
    if (otpRequestedAt == null) return true;
    final elapsed = DateTime.now().difference(otpRequestedAt!).inMinutes;
    return elapsed >= otpExpiryMinutes;
  }

  /// Validation domain d'un numéro de téléphone CI (10 chiffres).
  static bool isValidPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\s+'), '');
    return cleaned.length == 10 && RegExp(r'^[0-9]+$').hasMatch(cleaned);
  }

  /// `true` si le code OTP est complet (4 chiffres).
  static bool isOtpComplete(String otp) {
    return otp.length == otpLength && RegExp(r'^[0-9]+$').hasMatch(otp);
  }

  /// Numéro formaté pour affichage : +225 07 08 09 10 11
  String get formattedPhone {
    final cleaned = phone.replaceAll(RegExp(r'\s+'), '');
    if (cleaned.length != 10) return '+225 $phone';
    return '+225 ${cleaned.substring(0, 2)} ${cleaned.substring(2, 4)} '
        '${cleaned.substring(4, 6)} ${cleaned.substring(6, 8)} '
        '${cleaned.substring(8, 10)}';
  }

  AuthSession copyWith({
    String? phone,
    DateTime? otpRequestedAt,
    bool? isVerified,
  }) {
    return AuthSession(
      phone: phone ?? this.phone,
      otpRequestedAt: otpRequestedAt ?? this.otpRequestedAt,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  @override
  List<Object?> get props => [phone, otpRequestedAt, isVerified];
}
