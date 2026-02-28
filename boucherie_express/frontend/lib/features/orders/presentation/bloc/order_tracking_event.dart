part of 'order_tracking_bloc.dart';

/// Événements du BLoC de suivi de commande.
sealed class OrderTrackingEvent extends Equatable {
  const OrderTrackingEvent();

  @override
  List<Object?> get props => [];
}

/// Charge le suivi d'une commande.
final class LoadOrderTracking extends OrderTrackingEvent {
  final String orderId;

  const LoadOrderTracking({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

/// Rafraîchit le statut (pull-to-refresh ou polling).
final class RefreshOrderTracking extends OrderTrackingEvent {
  const RefreshOrderTracking();
}
