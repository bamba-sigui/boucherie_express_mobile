import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/address.dart';
import '../../domain/repositories/address_repository.dart';

/// Implémentation mock du repository d'adresses.
///
/// Données stockées en mémoire pour le développement.
/// À remplacer par une datasource Firebase / API.
@Injectable(as: AddressRepository)
class AddressRepositoryImpl implements AddressRepository {
  final List<Address> _addresses = [
    const Address(
      id: 'addr_1',
      label: 'Maison',
      fullAddress: '12 Rue des Jardins, Cocody, Abidjan',
      isDefault: true,
      type: AddressType.home,
    ),
    const Address(
      id: 'addr_2',
      label: 'Bureau',
      fullAddress: 'Immeuble CCIA, Plateau, Abidjan',
      isDefault: false,
      type: AddressType.work,
    ),
    const Address(
      id: 'addr_3',
      label: 'Parents',
      fullAddress: 'Quartier Kennedy, Bouaké',
      isDefault: false,
      type: AddressType.other,
    ),
  ];

  @override
  Future<Either<Failure, List<Address>>> getAddresses() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return Right(List.unmodifiable(_addresses));
  }

  @override
  Future<Either<Failure, List<Address>>> setDefaultAddress(
    String addressId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final index = _addresses.indexWhere((a) => a.id == addressId);
    if (index == -1) {
      return const Left(NotFoundFailure('Adresse introuvable'));
    }

    for (var i = 0; i < _addresses.length; i++) {
      _addresses[i] = _addresses[i].copyWith(
        isDefault: _addresses[i].id == addressId,
      );
    }

    return Right(List.unmodifiable(_addresses));
  }

  @override
  Future<Either<Failure, List<Address>>> deleteAddress(String addressId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final index = _addresses.indexWhere((a) => a.id == addressId);
    if (index == -1) {
      return const Left(NotFoundFailure('Adresse introuvable'));
    }

    final wasDefault = _addresses[index].isDefault;
    _addresses.removeAt(index);

    // Si l'adresse supprimée était la défaut, on promeut la première
    if (wasDefault && _addresses.isNotEmpty) {
      _addresses[0] = _addresses[0].copyWith(isDefault: true);
    }

    return Right(List.unmodifiable(_addresses));
  }

  @override
  Future<Either<Failure, List<Address>>> addAddress(Address address) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final newAddress = address.copyWith(
      id: 'addr_${DateTime.now().millisecondsSinceEpoch}',
      isDefault: _addresses.isEmpty,
    );

    _addresses.add(newAddress);
    return Right(List.unmodifiable(_addresses));
  }
}
