import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/address.dart';
import '../repositories/address_repository.dart';

/// Définit une adresse comme adresse par défaut.
@injectable
class SetDefaultAddress implements UseCase<List<Address>, String> {
  final AddressRepository repository;

  SetDefaultAddress(this.repository);

  @override
  Future<Either<Failure, List<Address>>> call(String addressId) {
    return repository.setDefaultAddress(addressId);
  }
}
