import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/address.dart';
import '../repositories/address_repository.dart';

/// Récupère toutes les adresses de l'utilisateur.
@injectable
class GetAddresses implements UseCaseNoParams<List<Address>> {
  final AddressRepository repository;

  GetAddresses(this.repository);

  @override
  Future<Either<Failure, List<Address>>> call() {
    return repository.getAddresses();
  }
}
