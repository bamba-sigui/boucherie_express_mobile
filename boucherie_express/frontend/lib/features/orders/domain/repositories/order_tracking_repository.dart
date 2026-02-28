import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/order_tracking.dart';

/// Contrat du repository order tracking.
abstract class OrderTrackingRepository {
  /// Récupère les données de suivi pour une commande.
  Future<Either<Failure, OrderTracking>> getOrderTracking(String orderId);

  /// Rafraîchit le statut (simule polling).
  Future<Either<Failure, OrderTracking>> refreshOrderStatus(String orderId);
}
