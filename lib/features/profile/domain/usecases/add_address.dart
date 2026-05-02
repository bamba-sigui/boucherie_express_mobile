import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/address.dart';
import '../repositories/address_repository.dart';

@injectable
class AddAddress {
  final AddressRepository repository;

  AddAddress(this.repository);

  Future<Either<Failure, List<Address>>> call(Address address) {
    return repository.addAddress(address);
  }
}
