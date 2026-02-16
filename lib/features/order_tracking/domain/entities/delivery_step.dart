import 'package:equatable/equatable.dart';

import 'delivery_status.dart';

/// Une étape de la timeline de livraison.
class DeliveryStep extends Equatable {
  final String id;
  final String label;
  final String? subtitle;
  final DeliveryStatus status;
  final DateTime? completedAt;

  /// Icône Material Symbols associée à cette étape.
  final String iconName;

  const DeliveryStep({
    required this.id,
    required this.label,
    this.subtitle,
    required this.status,
    this.completedAt,
    required this.iconName,
  });

  bool get isCompleted => status == DeliveryStatus.completed;
  bool get isActive => status == DeliveryStatus.active;
  bool get isPending => status == DeliveryStatus.pending;

  @override
  List<Object?> get props => [id, label, status, completedAt];
}
