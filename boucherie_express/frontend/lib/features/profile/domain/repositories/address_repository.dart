import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/address.dart';

/// Contrat du repository d'adresses.
abstract class AddressRepository {
  /// Récupère la liste des adresses de l'utilisateur.
  Future<Either<Failure, List<Address>>> getAddresses();

  /// Définit l'adresse [addressId] comme adresse par défaut.
  Future<Either<Failure, List<Address>>> setDefaultAddress(String addressId);

  /// Supprime l'adresse [addressId].
  Future<Either<Failure, List<Address>>> deleteAddress(String addressId);

  /// Ajoute une nouvelle adresse.
  Future<Either<Failure, List<Address>>> addAddress(Address address);
}
