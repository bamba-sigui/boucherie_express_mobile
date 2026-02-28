import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

/// Remote data source for authentication
abstract class AuthRemoteDataSource {
  /// Get current user
  Future<UserModel?> getCurrentUser();

  /// Sign in with email and password
  Future<UserModel> signInWithEmail(String email, String password);

  /// Sign up with email and password
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    String? phone,
  });

  /// Sign out
  Future<void> signOut();

  /// Reset password
  Future<void> resetPassword(String email);

  /// Update user profile
  Future<UserModel> updateUserProfile({
    String? name,
    String? phone,
    List<String>? addresses,
  });

  /// Check if user is signed in
  Future<bool> isSignedIn();

  /// Stream of auth state changes
  Stream<UserModel?> get authStateChanges;
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl(this.firebaseAuth, this.firestore);

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final firebaseUser = firebaseAuth.currentUser;
      if (firebaseUser == null) return null;

      final doc = await firestore
          .collection(AppConstants.collectionUsers)
          .doc(firebaseUser.uid)
          .get();

      if (!doc.exists) return null;

      return UserModel.fromJson({...doc.data()!, 'id': firebaseUser.uid});
    } catch (e) {
      throw ServerException('Erreur lors de la récupération de l\'utilisateur');
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

      final doc = await firestore
          .collection(AppConstants.collectionUsers)
          .doc(credential.user!.uid)
          .get();

      if (!doc.exists) {
        throw AuthException('Utilisateur introuvable');
      }

      return UserModel.fromJson({...doc.data()!, 'id': credential.user!.uid});
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_getAuthErrorMessage(e.code), e.code);
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

      final user = UserModel(
        id: credential.user!.uid,
        email: email,
        name: name,
        phone: phone,
        createdAt: DateTime.now(),
      );

      await firestore
          .collection(AppConstants.collectionUsers)
          .doc(user.id)
          .set(user.toJson());

      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_getAuthErrorMessage(e.code), e.code);
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
      throw AuthException('Erreur lors de la réinitialisation du mot de passe');
    }
  }

  @override
  Future<UserModel> updateUserProfile({
    String? name,
    String? phone,
    List<String>? addresses,
  }) async {
    try {
      final firebaseUser = firebaseAuth.currentUser;
      if (firebaseUser == null) {
        throw AuthException('Utilisateur non connecté');
      }

      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (phone != null) updates['phone'] = phone;
      if (addresses != null) updates['addresses'] = addresses;

      await firestore
          .collection(AppConstants.collectionUsers)
          .doc(firebaseUser.uid)
          .update(updates);

      final doc = await firestore
          .collection(AppConstants.collectionUsers)
          .doc(firebaseUser.uid)
          .get();

      return UserModel.fromJson({...doc.data()!, 'id': firebaseUser.uid});
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
        final doc = await firestore
            .collection(AppConstants.collectionUsers)
            .doc(firebaseUser.uid)
            .get();

        if (!doc.exists) return null;

        return UserModel.fromJson({...doc.data()!, 'id': firebaseUser.uid});
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
