import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';

/// Local data source for onboarding
abstract class OnboardingLocalDataSource {
  /// Check if onboarding has been completed
  Future<bool> isOnboardingCompleted();

  /// Mark onboarding as completed
  Future<void> completeOnboarding();
}

@LazySingleton(as: OnboardingLocalDataSource)
class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SharedPreferences sharedPreferences;

  OnboardingLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<bool> isOnboardingCompleted() async {
    try {
      return sharedPreferences.getBool(AppConstants.keyOnboardingCompleted) ??
          false;
    } catch (e) {
      throw CacheException(
        'Erreur lors de la vérification du statut onboarding',
      );
    }
  }

  @override
  Future<void> completeOnboarding() async {
    try {
      await sharedPreferences.setBool(
        AppConstants.keyOnboardingCompleted,
        true,
      );
    } catch (e) {
      throw CacheException('Erreur lors de la sauvegarde du statut onboarding');
    }
  }
}
