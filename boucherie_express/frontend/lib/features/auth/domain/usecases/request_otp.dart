import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/phone_auth_repository.dart';

/// Demande l'envoi d'un code OTP par SMS.
@lazySingleton
class RequestOtp implements UseCase<void, RequestOtpParams> {
  final PhoneAuthRepository repository;

  RequestOtp(this.repository);

  @override
  Future<Either<Failure, void>> call(RequestOtpParams params) {
    return repository.requestOtp(params.phone);
  }
}

class RequestOtpParams extends Equatable {
  final String phone;

  const RequestOtpParams({required this.phone});

  @override
  List<Object?> get props => [phone];
}
