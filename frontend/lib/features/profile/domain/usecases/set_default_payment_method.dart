import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/payment_method.dart';
import '../repositories/payment_method_repository.dart';

/// Définit un moyen de paiement comme méthode par défaut.
@injectable
class SetDefaultPaymentMethod implements UseCase<List<PaymentMethod>, String> {
  final PaymentMethodRepository repository;

  SetDefaultPaymentMethod(this.repository);

  @override
  Future<Either<Failure, List<PaymentMethod>>> call(String methodId) {
    return repository.setDefaultPaymentMethod(methodId);
  }
}
