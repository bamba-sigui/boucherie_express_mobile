import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

/// Authentication repository interface
abstract class AuthRepository {
  /// Get current user
  Future<Either<Failure, User?>> getCurrentUser();

  /// Sign in with email and password
  Future<Either<Failure, User>> signInWithEmail(String email, String password);

  /// Sign up with email and password
  Future<Either<Failure, User>> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    String? phone,
  });

  /// Sign out
  Future<Either<Failure, void>> signOut();

  /// Reset password
  Future<Either<Failure, void>> resetPassword(String email);

  /// Update user profile
  Future<Either<Failure, User>> updateUserProfile({
    String? name,
    String? phone,
    List<String>? addresses,
  });

  /// Check if user is signed in
  Future<Either<Failure, bool>> isSignedIn();

  /// Sign in with Google
  Future<Either<Failure, User>> signInWithGoogle();

  /// Check if a phone number already has a registered account
  Future<Either<Failure, bool>> checkPhoneExists(String phone);

  /// Check if an email already has a registered account
  Future<Either<Failure, bool>> checkEmailExists(String email);

  /// Stream of auth state changes
  Stream<User?> get authStateChanges;
}
