import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/phone_auth_repository.dart';

/// Renvoie un code OTP par SMS.
@lazySingleton
class ResendOtp implements UseCase<void, ResendOtpParams> {
  final PhoneAuthRepository repository;

  ResendOtp(this.repository);

  @override
  Future<Either<Failure, void>> call(ResendOtpParams params) {
    return repository.resendOtp(params.phone);
  }
}

class ResendOtpParams extends Equatable {
  final String phone;

  const ResendOtpParams({required this.phone});

  @override
  List<Object?> get props => [phone];
}
