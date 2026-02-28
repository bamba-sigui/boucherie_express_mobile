import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Header d'authentification avec logo Boucherie Express.
///
/// Design Stitch (home_16) :
/// - Icône restaurant dans cercle bg-primary/10, rounded-3xl (24px)
/// - BOUCHERIE EXPRESS en uppercase font-black tracking-tighter
/// - Sous-titre « Connexion / Inscription »
class AuthHeader extends StatelessWidget {
  final String? subtitle;

  const AuthHeader({super.key, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(
            Icons.restaurant_rounded,
            color: AppColors.primary,
            size: 36,
          ),
        ),
        const SizedBox(height: 24),

        // Title
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              color: Colors.white,
            ),
            children: [
              TextSpan(text: 'BOUCHERIE '),
              TextSpan(
                text: 'EXPRESS',
                style: TextStyle(color: AppColors.primary),
              ),
            ],
          ),
        ),

        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: TextStyle(
              color: Colors.white.withValues(alpha: .4),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
