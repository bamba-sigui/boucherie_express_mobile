import 'package:equatable/equatable.dart';

import 'courier.dart';
import 'delivery_status.dart';
import 'delivery_step.dart';

/// Agrégat de suivi de commande.
///
/// Contient les étapes de la timeline, le livreur, et l'ETA.
/// Toute la logique métier de statut est ici.
class OrderTracking extends Equatable {
  final String orderId;
  final List<DeliveryStep> steps;
  final Courier? courier;
  final DateTime? estimatedArrival;
  final DateTime? deliveredAt;

  /// URL d'image de fond statique (map preview).
  final String? mapImageUrl;

  const OrderTracking({
    required this.orderId,
    required this.steps,
    this.courier,
    this.estimatedArrival,
    this.deliveredAt,
    this.mapImageUrl,
  });

  // ── Business rules ────────────────────────────────────────────────────

  /// Étape actuellement active.
  DeliveryStep? get activeStep {
    try {
      return steps.firstWhere((s) => s.status == DeliveryStatus.active);
    } catch (_) {
      return null;
    }
  }

  /// Index de l'étape active (pour la timeline).
  int get activeStepIndex {
    final idx = steps.indexWhere((s) => s.status == DeliveryStatus.active);
    return idx >= 0 ? idx : steps.length;
  }

  /// `true` si la commande est livrée (toutes étapes complétées).
  bool get isDelivered => steps.isNotEmpty && steps.every((s) => s.isCompleted);

  /// Label du statut courant.
  String get currentStatusLabel {
    if (isDelivered) return 'Livrée';
    return activeStep?.label ?? 'En attente';
  }

  /// ETA formaté : "dans X min" ou "Livrée à HH:mm".
  String get formattedETA {
    if (isDelivered && deliveredAt != null) {
      final h = deliveredAt!.hour.toString().padLeft(2, '0');
      final m = deliveredAt!.minute.toString().padLeft(2, '0');
      return 'Livrée à $h:$m';
    }

    if (estimatedArrival == null) return '';

    final now = DateTime.now();
    final diff = estimatedArrival!.difference(now);

    if (diff.isNegative) return 'Imminent';

    final minutes = diff.inMinutes;
    if (minutes <= 0) return 'Imminent';
    return 'dans $minutes min';
  }

  /// ETA en format heure (HH:mm).
  String get etaTime {
    if (estimatedArrival == null) return '--:--';
    final h = estimatedArrival!.hour.toString().padLeft(2, '0');
    final m = estimatedArrival!.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// `true` si on peut appeler le livreur.
  bool get canCallCourier =>
      courier != null && courier!.canCall && !isDelivered;

  /// Message contextuel pour le banner ETA.
  String get etaBannerMessage {
    if (isDelivered) return 'Commande livrée';
    if (courier != null) {
      return '${courier!.name} arrive $formattedETA';
    }
    return 'Arrivée estimée $formattedETA';
  }

  @override
  List<Object?> get props => [orderId, steps, courier, estimatedArrival];
}
