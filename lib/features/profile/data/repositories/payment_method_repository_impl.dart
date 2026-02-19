import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/repositories/payment_method_repository.dart';

/// Implémentation mock du repository des moyens de paiement.
///
/// Données en mémoire pour le développement.
@Injectable(as: PaymentMethodRepository)
class PaymentMethodRepositoryImpl implements PaymentMethodRepository {
  final List<PaymentMethod> _methods = [
    const PaymentMethod(
      id: 'pm_wave',
      type: PaymentMethodType.wave,
      providerName: 'Wave',
      phoneNumber: '0708091011',
      isDefault: true,
      status: PaymentMethodStatus.connected,
    ),
    const PaymentMethod(
      id: 'pm_orange',
      type: PaymentMethodType.orangeMoney,
      providerName: 'Orange Money',
      status: PaymentMethodStatus.notConfigured,
    ),
    const PaymentMethod(
      id: 'pm_momo',
      type: PaymentMethodType.momo,
      providerName: 'MTN MoMo',
      status: PaymentMethodStatus.notConfigured,
    ),
    const PaymentMethod(
      id: 'pm_cash',
      type: PaymentMethodType.cash,
      providerName: 'Paiement à la livraison',
      status: PaymentMethodStatus.connected,
    ),
  ];

  @override
  Future<Either<Failure, List<PaymentMethod>>> getPaymentMethods() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Right(List.unmodifiable(_methods));
  }

  @override
  Future<Either<Failure, List<PaymentMethod>>> addPaymentMethod(
    PaymentMethod method,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));

    // Si le type existe déjà, on le met à jour (configuration)
    final index = _methods.indexWhere((m) => m.type == method.type);
    if (index != -1) {
      _methods[index] = _methods[index].copyWith(
        phoneNumber: method.phoneNumber,
        cardLastDigits: method.cardLastDigits,
        expiryDate: method.expiryDate,
        status: PaymentMethodStatus.connected,
      );
    } else {
      _methods.add(method.copyWith(
        id: 'pm_${DateTime.now().millisecondsSinceEpoch}',
        status: PaymentMethodStatus.connected,
      ));
    }

    return Right(List.unmodifiable(_methods));
  }

  @override
  Future<Either<Failure, List<PaymentMethod>>> removePaymentMethod(
    String methodId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final index = _methods.indexWhere((m) => m.id == methodId);
    if (index == -1) {
      return const Left(NotFoundFailure('Moyen de paiement introuvable'));
    }

    _methods.removeAt(index);
    return Right(List.unmodifiable(_methods));
  }

  @override
  Future<Either<Failure, List<PaymentMethod>>> setDefaultPaymentMethod(
    String methodId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _methods.indexWhere((m) => m.id == methodId);
    if (index == -1) {
      return const Left(NotFoundFailure('Moyen de paiement introuvable'));
    }

    for (var i = 0; i < _methods.length; i++) {
      _methods[i] = _methods[i].copyWith(
        isDefault: _methods[i].id == methodId,
      );
    }

    return Right(List.unmodifiable(_methods));
  }
}
