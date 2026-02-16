import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Bouton final "Valider la commande" avec états disabled / loading / enabled.
///
/// Design : bg-primary, full-width, h-16, rounded-full, font-extrabold,
///          shadow-lg shadow-primary/20, icône shopping_cart_checkout.
class PlaceOrderButton extends StatelessWidget {
  final bool enabled;
  final bool isLoading;
  final VoidCallback onPressed;

  const PlaceOrderButton({
    super.key,
    required this.enabled,
    this.isLoading = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = enabled && !isLoading;

    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: isActive ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: .3),
          foregroundColor: AppColors.backgroundDark,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: .2),
          disabledForegroundColor: AppColors.backgroundDark.withValues(
            alpha: .4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          elevation: isActive ? 8 : 0,
          shadowColor: AppColors.primary.withValues(alpha: .2),
          padding: EdgeInsets.zero,
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: AppColors.backgroundDark,
                  strokeWidth: 2.5,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Valider la commande',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.shopping_cart_checkout_rounded, size: 22),
                ],
              ),
      ),
    );
  }
}
