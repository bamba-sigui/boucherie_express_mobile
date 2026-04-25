import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

/// Repository interface for onboarding
abstract class OnboardingRepository {
  /// Check if onboarding has been completed
  Future<Either<Failure, bool>> isOnboardingCompleted();

  /// Mark onboarding as completed
  Future<Either<Failure, void>> completeOnboarding();
}
