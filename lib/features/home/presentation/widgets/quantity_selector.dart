import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Inline quantity selector with minus / count / plus controls.
///
/// Design spec:
/// - Label: "QUANTITÉ" uppercase, tracking-widest, white/50
/// - Container: bg-cardDark, border white/10, rounded-2xl, p-1.5
/// - Minus btn: size-10 rounded-xl bg-white/5
/// - Plus btn: size-10 rounded-xl bg-primary text-backgroundDark
/// - Count: text-lg font-bold
class QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.min = 1,
    this.max = 99,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Label
        Text(
          'QUANTITÉ',
          style: TextStyle(
            color: Colors.white.withValues(alpha: .5),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 3,
          ),
        ),
        const Spacer(),

        // Selector control
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: .1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Minus
              _ControlButton(
                icon: Icons.remove_rounded,
                backgroundColor: Colors.white.withValues(alpha: .05),
                iconColor: quantity <= min
                    ? Colors.white.withValues(alpha: .25)
                    : Colors.white,
                onTap: quantity > min ? () => onChanged(quantity - 1) : null,
              ),

              // Count
              SizedBox(
                width: 48,
                child: Text(
                  '$quantity',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Plus
              _ControlButton(
                icon: Icons.add_rounded,
                backgroundColor: AppColors.primary,
                iconColor: AppColors.backgroundDark,
                onTap: quantity < max ? () => onChanged(quantity + 1) : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback? onTap;

  const _ControlButton({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}
