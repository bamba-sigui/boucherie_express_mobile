import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/address.dart';
import '../repositories/address_repository.dart';

/// Supprime une adresse par son identifiant.
@injectable
class DeleteAddress implements UseCase<List<Address>, String> {
  final AddressRepository repository;

  DeleteAddress(this.repository);

  @override
  Future<Either<Failure, List<Address>>> call(String addressId) {
    return repository.deleteAddress(addressId);
  }
}
