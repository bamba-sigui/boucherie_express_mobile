import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/faq_item.dart';
import '../../domain/entities/support_contact.dart';
import '../../domain/repositories/support_repository.dart';
import '../datasources/support_local_datasource.dart';

/// Implémentation du repository Support (données locales).
@Injectable(as: SupportRepository)
class SupportRepositoryImpl implements SupportRepository {
  final SupportLocalDatasource _localDatasource;

  SupportRepositoryImpl(this._localDatasource);

  @override
  Future<Either<Failure, List<FaqItem>>> getFaqs() async {
    try {
      final faqs = await _localDatasource.getFaqs();
      return Right(faqs);
    } catch (e) {
      return const Left(CacheFailure('Impossible de charger les FAQ'));
    }
  }

  @override
  Future<Either<Failure, List<SupportContact>>> getSupportContacts() async {
    try {
      final contacts = await _localDatasource.getSupportContacts();
      return Right(contacts);
    } catch (e) {
      return const Left(
        CacheFailure('Impossible de charger les contacts support'),
      );
    }
  }
}
