part of 'phone_auth_bloc.dart';

/// États du flux d'authentification par téléphone.
sealed class PhoneAuthState extends Equatable {
  const PhoneAuthState();

  @override
  List<Object?> get props => [];
}

/// État initial.
final class PhoneAuthInitial extends PhoneAuthState {}

/// OTP en cours d'envoi (loading sur PhoneInputScreen).
final class OtpRequesting extends PhoneAuthState {}

/// OTP envoyé avec succès → naviguer vers OTPVerificationScreen.
final class OtpSentSuccess extends PhoneAuthState {
  final String phone;
  final String formattedPhone;

  const OtpSentSuccess({required this.phone, required this.formattedPhone});

  @override
  List<Object?> get props => [phone, formattedPhone];
}

/// OTP en cours de vérification (loading sur OTPVerificationScreen).
final class OtpVerifying extends PhoneAuthState {}

/// OTP vérifié → naviguer vers Home.
final class OtpVerifiedSuccess extends PhoneAuthState {
  final User user;

  const OtpVerifiedSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

/// OTP renvoyé → feedback + reset du timer.
final class OtpResent extends PhoneAuthState {
  final String phone;
  final String formattedPhone;

  const OtpResent({required this.phone, required this.formattedPhone});

  @override
  List<Object?> get props => [phone, formattedPhone];
}

/// Erreur (réseau, code incorrect, etc.).
final class PhoneAuthError extends PhoneAuthState {
  final String message;

  const PhoneAuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Vérification de l'existence du compte en cours.
final class PhoneChecking extends PhoneAuthState {}

/// Aucun compte trouvé pour ce numéro → rediriger vers l'inscription.
final class PhoneNotRegistered extends PhoneAuthState {
  final String phone;

  const PhoneNotRegistered({required this.phone});

  @override
  List<Object?> get props => [phone];
}
