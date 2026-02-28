import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/faq_item.dart';
import '../entities/support_contact.dart';

/// Contrat du repository Support.
abstract class SupportRepository {
  /// Récupère la liste des FAQ.
  Future<Either<Failure, List<FaqItem>>> getFaqs();

  /// Récupère la liste des contacts support.
  Future<Either<Failure, List<SupportContact>>> getSupportContacts();
}
