import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/phone_auth_repository.dart';

/// Vérifie le code OTP et retourne l'utilisateur authentifié.
@lazySingleton
class VerifyOtp implements UseCase<User, VerifyOtpParams> {
  final PhoneAuthRepository repository;

  VerifyOtp(this.repository);

  @override
  Future<Either<Failure, User>> call(VerifyOtpParams params) {
    return repository.verifyOtp(params.phone, params.code);
  }
}

class VerifyOtpParams extends Equatable {
  final String phone;
  final String code;

  const VerifyOtpParams({required this.phone, required this.code});

  @override
  List<Object?> get props => [phone, code];
}
