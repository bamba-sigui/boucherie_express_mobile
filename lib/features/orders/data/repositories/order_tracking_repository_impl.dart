import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/courier.dart';
import '../../domain/entities/delivery_status.dart';
import '../../domain/entities/delivery_step.dart';
import '../../domain/entities/order_tracking.dart';
import '../../domain/repositories/order_tracking_repository.dart';

/// Implémentation mock du repository de suivi de commande.
///
/// Simule un délai réseau et retourne des données de test
/// correspondant au design Stitch « Track My Order ».
@LazySingleton(as: OrderTrackingRepository)
class OrderTrackingRepositoryImpl implements OrderTrackingRepository {
  @override
  Future<Either<Failure, OrderTracking>> getOrderTracking(
    String orderId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return Right(_createMockTracking(orderId));
  }

  @override
  Future<Either<Failure, OrderTracking>> refreshOrderStatus(
    String orderId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return Right(_createMockTracking(orderId));
  }

  // ── Mock data ──────────────────────────────────────────────────────────

  OrderTracking _createMockTracking(String orderId) {
    final now = DateTime.now();

    return OrderTracking(
      orderId: orderId,
      estimatedArrival: now.add(const Duration(minutes: 12)),
      mapImageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAHqWLOzjOh8PsvDws5xUEku7XFX5Ok5EQX3HyOZuKqWb3Lhc_8n1myKraLbEMCXzJuxRuqkU7RIN40PVh2PbjKsPWs2FfzyQVeuOzD59OTgdH07jcgXS4Gctwk0iOi3W9JHiIxL5LUGgJq39urbdL27hJD0CGp68-TgNPTL4oR7ajj1FtYv3lfco8kmoMnVmSjUdaZrDV3zkQt4Q7gNSH54eCsJu1soXsVu6UPKvuMoFRguWSxVyFqHJNAtQ-6D4SaYGsSXpN-Lw',
      courier: const Courier(
        id: 'courier_1',
        name: 'Koffi Konan',
        rating: 4.9,
        vehicle: 'Yamaha TMAX',
        phone: '+2250700000000',
        photoUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCw0nxpECjjVMN5Si5uy-HbacH6LgbNZ1cEXHJoL8_SqWhR-2T7wTev3VJRp_rB-c366GYuh4XpE4WHGW37hKgel7AJhrwSahZEe60tUje6trM21O5fag-DeRHp9Jcm34IHAP1jlNIwYqxzPF1KSBlVTk9GjMkxeEJWu78IXYalJ-EaSFDlPs2YEUAwU43xYGf3ayQtBRzNsq4j-vaBZWBr53YkOYW74tqjGB3U1_vdui1uHQkaoIw_IrrO34kQGjCIckTgBuw8nw',
      ),
      steps: [
        DeliveryStep(
          id: 'step_prep',
          label: 'En préparation',
          subtitle: 'Votre commande est prête',
          status: DeliveryStatus.completed,
          completedAt: now.subtract(const Duration(minutes: 25)),
          iconName: 'restaurant',
        ),
        const DeliveryStep(
          id: 'step_delivering',
          label: 'En cours de livraison',
          subtitle: 'Le livreur est en route',
          status: DeliveryStatus.active,
          iconName: 'two_wheeler',
        ),
        const DeliveryStep(
          id: 'step_delivered',
          label: 'Livrée',
          status: DeliveryStatus.pending,
          iconName: 'where_to_vote',
        ),
      ],
    );
  }
}
