import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:injectable/injectable.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

/// Remote data source for authentication.
///
/// Uses Firebase Auth for sign in/up/out (client-side) and the backend API
/// for profile operations.
abstract class AuthRemoteDataSource {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> signInWithEmail(String email, String password);
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    String? phone,
  });
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<UserModel> updateUserProfile({
    String? name,
    String? phone,
    List<String>? addresses,
  });
  Future<bool> isSignedIn();
  Stream<UserModel?> get authStateChanges;
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.firebaseAuth, this.apiClient);

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final firebaseUser = firebaseAuth.currentUser;
      if (firebaseUser == null) return null;

      final data = await apiClient.get(ApiConstants.profile);
      return UserModel.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw ServerException(
        'Erreur lors de la récupération de l\'utilisateur',
      );
    }
  }

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw AuthException('Échec de la connexion');
      }

      // Fetch profile from backend API
      final data = await apiClient.get(ApiConstants.profile);
      return UserModel.fromJson(data as Map<String, dynamic>);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_getAuthErrorMessage(e.code), e.code);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Erreur lors de la connexion');
    }
  }

  @override
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw AuthException('Échec de l\'inscription');
      }

      // Update profile on the backend (which creates the user document)
      final data = await apiClient.put(
        ApiConstants.profile,
        data: {
          'name': name,
          if (phone != null) 'phone': phone,
        },
      );
      return UserModel.fromJson(data as Map<String, dynamic>);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_getAuthErrorMessage(e.code), e.code);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Erreur lors de l\'inscription');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw AuthException('Erreur lors de la déconnexion');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_getAuthErrorMessage(e.code), e.code);
    } catch (e) {
      throw AuthException(
        'Erreur lors de la réinitialisation du mot de passe',
      );
    }
  }

  @override
  Future<UserModel> updateUserProfile({
    String? name,
    String? phone,
    List<String>? addresses,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (phone != null) updates['phone'] = phone;

      final data = await apiClient.put(ApiConstants.profile, data: updates);
      return UserModel.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw AuthException('Erreur lors de la mise à jour du profil');
    }
  }

  @override
  Future<bool> isSignedIn() async {
    return firebaseAuth.currentUser != null;
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;

      try {
        final data = await apiClient.get(ApiConstants.profile);
        return UserModel.fromJson(data as Map<String, dynamic>);
      } catch (e) {
        return null;
      }
    });
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Aucun utilisateur trouvé avec cet email';
      case 'wrong-password':
        return 'Mot de passe incorrect';
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé';
      case 'invalid-email':
        return 'Email invalide';
      case 'weak-password':
        return 'Le mot de passe est trop faible';
      case 'user-disabled':
        return 'Ce compte a été désactivé';
      default:
        return 'Une erreur s\'est produite';
    }
  }
}
