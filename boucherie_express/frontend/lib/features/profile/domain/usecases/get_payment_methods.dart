import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/payment_method.dart';
import '../repositories/payment_method_repository.dart';

/// Récupère tous les moyens de paiement de l'utilisateur.
@injectable
class GetPaymentMethods implements UseCaseNoParams<List<PaymentMethod>> {
  final PaymentMethodRepository repository;

  GetPaymentMethods(this.repository);

  @override
  Future<Either<Failure, List<PaymentMethod>>> call() {
    return repository.getPaymentMethods();
  }
}
