import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/onboarding_repository.dart';

@lazySingleton
class CheckOnboardingStatus implements UseCaseNoParams<bool> {
  final OnboardingRepository repository;

  CheckOnboardingStatus(this.repository);

  @override
  Future<Either<Failure, bool>> call() {
    return repository.isOnboardingCompleted();
  }
}
