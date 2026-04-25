import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../domain/entities/cart.dart';

/// Financial summary : sub-total, delivery, total + taxes mention.
class CartSummary extends StatelessWidget {
  final Cart cart;

  const CartSummary({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sous-total
        _SummaryRow(
          label: 'Sous-total',
          value: FormatUtils.formatPrice(cart.subtotal),
        ),
        const SizedBox(height: 16),

        // Frais de livraison
        _SummaryRow(
          label: 'Frais de livraison',
          value: cart.hasFreeDelivery
              ? 'Gratuit'
              : FormatUtils.formatPrice(cart.deliveryFee),
          valueColor: cart.hasFreeDelivery ? AppColors.primary : null,
        ),
        const SizedBox(height: 16),

        // Divider
        Container(height: 1, color: Colors.white.withValues(alpha: .05)),
        const SizedBox(height: 16),

        // Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  FormatUtils.formatPrice(cart.totalAmount),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'TAXES INCLUSES',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .35),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    letterSpacing: .5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
