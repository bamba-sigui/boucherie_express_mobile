import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/payment_method.dart';
import '../repositories/checkout_repository.dart';

/// Récupère la liste des méthodes de paiement disponibles.
@lazySingleton
class GetPaymentMethods implements UseCaseNoParams<List<PaymentMethod>> {
  final CheckoutRepository repository;

  GetPaymentMethods(this.repository);

  @override
  Future<Either<Failure, List<PaymentMethod>>> call() {
    return repository.getPaymentMethods();
  }
}
