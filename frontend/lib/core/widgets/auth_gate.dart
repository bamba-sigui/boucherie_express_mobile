import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../theme/app_colors.dart';

/// Vérifie l'état d'authentification via [AuthBloc] et affiche soit
/// le [child] protégé, soit un écran invitant l'utilisateur à se connecter.
class AuthGate extends StatelessWidget {
  final Widget child;
  final IconData icon;
  final String title;
  final String subtitle;

  const AuthGate({
    super.key,
    required this.child,
    this.icon = Icons.lock_outline_rounded,
    this.title = 'Connectez-vous',
    this.subtitle = 'Connectez-vous pour accéder à cette section.',
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) return child;
        return _LoginPrompt(icon: icon, title: title, subtitle: subtitle);
      },
    );
  }
}

class _LoginPrompt extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _LoginPrompt({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône dans un cercle vert
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 40, color: AppColors.primary),
              ),
              const SizedBox(height: 24),

              // Titre
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Sous-titre
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .5),
                  fontSize: 14,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Bouton « Se connecter »
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.push('/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.backgroundDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Se connecter',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Lien « Créer un compte »
              GestureDetector(
                onTap: () => context.push('/signup'),
                child: Text(
                  'Créer un compte',
                  style: TextStyle(
                    color: AppColors.primary.withValues(alpha: .8),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
