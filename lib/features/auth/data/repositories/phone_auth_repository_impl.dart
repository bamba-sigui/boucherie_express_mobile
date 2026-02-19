import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/phone_auth_repository.dart';

/// Implémentation mock du repository d'auth téléphone.
///
/// OTP valide : 1234
/// Délais simulés : requestOtp 1 s, verifyOtp 1.5 s, resendOtp 1 s.
/// Prête pour remplacement par une vraie API.
@LazySingleton(as: PhoneAuthRepository)
class PhoneAuthRepositoryImpl implements PhoneAuthRepository {
  static const _validOtp = '1234';

  @override
  Future<Either<Failure, void>> requestOtp(String phone) async {
    await Future.delayed(const Duration(seconds: 1));
    // Simule un envoi SMS réussi
    return const Right(null);
  }

  @override
  Future<Either<Failure, User>> verifyOtp(String phone, String code) async {
    await Future.delayed(const Duration(milliseconds: 1500));

    if (code == _validOtp) {
      return Right(
        User(
          id: 'mock-user-${DateTime.now().millisecondsSinceEpoch}',
          email: '',
          name: 'Utilisateur',
          phone: phone,
          createdAt: DateTime.now(),
        ),
      );
    }

    return const Left(AuthFailure('Code de vérification incorrect'));
  }

  @override
  Future<Either<Failure, void>> resendOtp(String phone) async {
    await Future.delayed(const Duration(seconds: 1));
    return const Right(null);
  }
}
