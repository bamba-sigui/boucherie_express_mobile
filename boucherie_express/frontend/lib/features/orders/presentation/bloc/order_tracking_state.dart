part of 'order_tracking_bloc.dart';

/// États du BLoC de suivi de commande.
sealed class OrderTrackingState extends Equatable {
  const OrderTrackingState();

  @override
  List<Object?> get props => [];
}

/// État initial.
final class OrderTrackingInitial extends OrderTrackingState {}

/// Chargement en cours.
final class OrderTrackingLoading extends OrderTrackingState {}

/// Données de suivi chargées.
final class OrderTrackingLoaded extends OrderTrackingState {
  final OrderTracking tracking;

  const OrderTrackingLoaded({required this.tracking});

  @override
  List<Object?> get props => [tracking];
}

/// Erreur de chargement.
final class OrderTrackingError extends OrderTrackingState {
  final String message;

  const OrderTrackingError({required this.message});

  @override
  List<Object?> get props => [message];
}
