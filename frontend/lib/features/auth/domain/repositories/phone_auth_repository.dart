import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

/// Repository d'authentification par téléphone + OTP.
///
/// Interface domain — l'implémentation (mock ou backend)
/// est injectée par le conteneur DI.
abstract class PhoneAuthRepository {
  /// Demande l'envoi d'un OTP au [phone].
  Future<Either<Failure, void>> requestOtp(String phone);

  /// Vérifie le [code] OTP pour le [phone].
  Future<Either<Failure, User>> verifyOtp(String phone, String code);

  /// Renvoie un OTP au [phone].
  Future<Either<Failure, void>> resendOtp(String phone);
}
