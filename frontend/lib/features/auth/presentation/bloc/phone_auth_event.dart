part of 'phone_auth_bloc.dart';

/// Événements du flux d'authentification par téléphone.
sealed class PhoneAuthEvent extends Equatable {
  const PhoneAuthEvent();

  @override
  List<Object?> get props => [];
}

/// L'utilisateur soumet son numéro de téléphone.
final class SubmitPhoneNumber extends PhoneAuthEvent {
  final String phone;

  const SubmitPhoneNumber({required this.phone});

  @override
  List<Object?> get props => [phone];
}

/// L'utilisateur soumet le code OTP.
final class SubmitOtp extends PhoneAuthEvent {
  final String phone;
  final String code;

  const SubmitOtp({required this.phone, required this.code});

  @override
  List<Object?> get props => [phone, code];
}

/// L'utilisateur demande le renvoi de l'OTP.
final class RequestResendOtp extends PhoneAuthEvent {
  final String phone;

  const RequestResendOtp({required this.phone});

  @override
  List<Object?> get props => [phone];
}
