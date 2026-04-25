import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/payment_method.dart';

/// Contrat du repository des moyens de paiement.
abstract class PaymentMethodRepository {
  /// Récupère la liste des moyens de paiement.
  Future<Either<Failure, List<PaymentMethod>>> getPaymentMethods();

  /// Ajoute / configure un moyen de paiement.
  Future<Either<Failure, List<PaymentMethod>>> addPaymentMethod(
    PaymentMethod method,
  );

  /// Supprime un moyen de paiement.
  Future<Either<Failure, List<PaymentMethod>>> removePaymentMethod(
    String methodId,
  );

  /// Définit un moyen de paiement comme défaut.
  Future<Either<Failure, List<PaymentMethod>>> setDefaultPaymentMethod(
    String methodId,
  );
}
