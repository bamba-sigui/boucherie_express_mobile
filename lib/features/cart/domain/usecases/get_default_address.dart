import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/delivery_address.dart';
import '../repositories/checkout_repository.dart';

/// Récupère l'adresse de livraison par défaut.
@lazySingleton
class GetDefaultAddress implements UseCaseNoParams<DeliveryAddress> {
  final CheckoutRepository repository;

  GetDefaultAddress(this.repository);

  @override
  Future<Either<Failure, DeliveryAddress>> call() {
    return repository.getDefaultAddress();
  }
}
