part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Email non enregistré → rediriger vers l'inscription.
class EmailNotRegistered extends AuthState {
  final String email;

  const EmailNotRegistered(this.email);

  @override
  List<Object?> get props => [email];
}

/// Connexion Google → nouvel utilisateur → rediriger vers l'inscription.
class GoogleNewUser extends AuthState {
  final String email;
  final String name;
  final String? photoUrl;

  const GoogleNewUser({required this.email, required this.name, this.photoUrl});

  @override
  List<Object?> get props => [email, name, photoUrl];
}
