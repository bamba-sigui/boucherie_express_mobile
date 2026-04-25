import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/onboarding_repository.dart';

@lazySingleton
class CompleteOnboarding implements UseCaseNoParams<void> {
  final OnboardingRepository repository;

  CompleteOnboarding(this.repository);

  @override
  Future<Either<Failure, void>> call() {
    return repository.completeOnboarding();
  }
}
