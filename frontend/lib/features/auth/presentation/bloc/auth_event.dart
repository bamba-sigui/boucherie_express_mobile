part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String? phone;

  const SignUpRequested({
    required this.email,
    required this.password,
    required this.name,
    this.phone,
  });

  @override
  List<Object?> get props => [email, password, name, phone];
}

class SignOutRequested extends AuthEvent {}

class ResetPasswordRequested extends AuthEvent {
  final String email;
  const ResetPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class SignInWithGoogleRequested extends AuthEvent {
  const SignInWithGoogleRequested();
}

class CheckAuthStatus extends AuthEvent {}

class AuthChanged extends AuthEvent {
  final User? user;
  const AuthChanged(this.user);

  @override
  List<Object?> get props => [user];
}

/// Vérifie l'existence du compte email avant de tenter la connexion.
class CheckEmailAndLogin extends AuthEvent {
  final String email;
  final String password;

  const CheckEmailAndLogin({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
