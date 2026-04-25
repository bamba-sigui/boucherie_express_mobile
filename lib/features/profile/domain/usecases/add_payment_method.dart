import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/payment_method.dart';
import '../repositories/payment_method_repository.dart';

/// Ajoute / configure un moyen de paiement.
@injectable
class AddPaymentMethod implements UseCase<List<PaymentMethod>, PaymentMethod> {
  final PaymentMethodRepository repository;

  AddPaymentMethod(this.repository);

  @override
  Future<Either<Failure, List<PaymentMethod>>> call(PaymentMethod method) {
    return repository.addPaymentMethod(method);
  }
}
