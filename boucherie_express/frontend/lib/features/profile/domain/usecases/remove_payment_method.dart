import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/payment_method.dart';
import '../repositories/payment_method_repository.dart';

/// Supprime un moyen de paiement par son identifiant.
@injectable
class RemovePaymentMethod implements UseCase<List<PaymentMethod>, String> {
  final PaymentMethodRepository repository;

  RemovePaymentMethod(this.repository);

  @override
  Future<Either<Failure, List<PaymentMethod>>> call(String methodId) {
    return repository.removePaymentMethod(methodId);
  }
}
