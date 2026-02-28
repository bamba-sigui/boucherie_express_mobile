import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/support_contact.dart';
import '../repositories/support_repository.dart';

/// Récupère la liste des contacts support.
@injectable
class GetSupportContacts extends UseCaseNoParams<List<SupportContact>> {
  final SupportRepository repository;

  GetSupportContacts(this.repository);

  @override
  Future<Either<Failure, List<SupportContact>>> call() {
    return repository.getSupportContacts();
  }
}
