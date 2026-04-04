import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// Vérifie si un numéro de téléphone est déjà enregistré.
@lazySingleton
class CheckPhoneExists implements UseCase<bool, CheckPhoneParams> {
  final AuthRepository repository;

  CheckPhoneExists(this.repository);

  @override
  Future<Either<Failure, bool>> call(CheckPhoneParams params) {
    return repository.checkPhoneExists(params.phone);
  }
}

class CheckPhoneParams extends Equatable {
  final String phone;

  const CheckPhoneParams({required this.phone});

  @override
  List<Object?> get props => [phone];
}
