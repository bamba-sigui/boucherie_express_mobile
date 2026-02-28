import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';

/// Résumé financier de la commande (sous-total, livraison, total).
///
/// Tous les montants proviennent du Cart via l'entité Checkout.
/// Aucun calcul ne se fait ici.
class CheckoutSummary extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double total;
  final int itemCount;

  const CheckoutSummary({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Sous-total
          _SummaryRow(
            label: 'Sous-total ($itemCount article${itemCount > 1 ? 's' : ''})',
            value: FormatUtils.formatPrice(subtotal),
          ),
          const SizedBox(height: 12),

          // Frais de livraison
          _SummaryRow(
            label: 'Frais de livraison',
            value: deliveryFee > 0
                ? FormatUtils.formatPrice(deliveryFee)
                : 'Gratuit',
            valueColor: AppColors.primary,
          ),
          const SizedBox(height: 12),

          // Divider
          Container(height: 1, color: Colors.white.withValues(alpha: .1)),
          const SizedBox(height: 12),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total à payer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                FormatUtils.formatPrice(total),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ],
      ),
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
            color: Colors.white.withValues(alpha: .5),
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
