import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Sticky bottom "COMMANDER →" button.
///
/// Design: bg-brandRed (#FF4B4B), h-16, rounded-2xl, uppercase tracking-widest.
class CheckoutBar extends StatelessWidget {
  final VoidCallback onCheckout;

  const CheckoutBar({super.key, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: onCheckout,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandRed,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          shadowColor: AppColors.brandRed.withValues(alpha: .3),
          padding: EdgeInsets.zero,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'COMMANDER',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
              ),
            ),
            SizedBox(width: 12),
            Icon(Icons.arrow_forward_rounded, size: 22),
          ],
        ),
      ),
    );
  }
}
