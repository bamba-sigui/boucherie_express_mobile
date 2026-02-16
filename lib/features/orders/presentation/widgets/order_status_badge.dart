import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/order.dart';

/// Badge de statut pour une commande.
///
/// Design Stitch (boucherie_express_home_11) :
/// - Pill shape (rounded-full)
/// - Background translucide (10%) + bordure (20%) de la couleur du statut
/// - Texte en majuscules, 10px, font-black, tracking-wider
///
/// Couleurs par statut :
/// - preparing → orange (#F59E0B)
/// - delivering → bleu (#3B82F6)
/// - delivered → vert (#10B981)
/// - pending → orange (même que preparing)
/// - confirmed → bleu
/// - cancelled → rouge
class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (Color color, String label) = _statusData(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  (Color, String) _statusData(OrderStatus status) {
    return switch (status) {
      OrderStatus.pending => (AppColors.statusOrange, 'En attente'),
      OrderStatus.confirmed => (AppColors.statusBlue, 'Confirmée'),
      OrderStatus.preparing => (AppColors.statusOrange, 'En préparation'),
      OrderStatus.delivering => (AppColors.statusBlue, 'En cours de livraison'),
      OrderStatus.delivered => (AppColors.statusGreen, 'Livrée'),
      OrderStatus.cancelled => (AppColors.error, 'Annulée'),
    };
  }
}
