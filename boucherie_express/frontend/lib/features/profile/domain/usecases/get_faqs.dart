import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/faq_item.dart';
import '../repositories/support_repository.dart';

/// Récupère la liste des questions fréquentes.
@injectable
class GetFaqs extends UseCaseNoParams<List<FaqItem>> {
  final SupportRepository repository;

  GetFaqs(this.repository);

  @override
  Future<Either<Failure, List<FaqItem>>> call() {
    return repository.getFaqs();
  }
}
