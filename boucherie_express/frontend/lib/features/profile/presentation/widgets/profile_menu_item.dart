import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Item de menu du profil.
///
/// Design Stitch (home_13) :
/// - bg-card-dark, rounded-xl, border white/5, p-4
/// - Icône dans cercle bg-white/5 size-10 à gauche (slate-300)
/// - Texte font-semibold slate-200
/// - chevron_right slate-500 à droite
/// - Effet pressed : bg-white/5 transition
class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.white.withValues(alpha: .05),
        highlightColor: Colors.white.withValues(alpha: .03),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: .05)),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon circle
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white.withValues(alpha: .7),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),

              // Title
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .85),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Chevron
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withValues(alpha: .3),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
