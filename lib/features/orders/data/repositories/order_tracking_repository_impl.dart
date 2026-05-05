import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/courier.dart';
import '../../domain/entities/delivery_status.dart';
import '../../domain/entities/delivery_step.dart';
import '../../domain/entities/order_tracking.dart';
import '../../domain/repositories/order_tracking_repository.dart';

/// Implémentation du repository de suivi connectée au backend Flask.
@LazySingleton(as: OrderTrackingRepository)
class OrderTrackingRepositoryImpl implements OrderTrackingRepository {
  final ApiClient _apiClient;

  OrderTrackingRepositoryImpl(this._apiClient);

  @override
  Future<Either<Failure, OrderTracking>> getOrderTracking(
    String orderId,
  ) async {
    try {
      final data = await _apiClient.get(
        ApiConstants.orderTracking(orderId),
      );
      return Right(_parseTracking(orderId, data as Map<String, dynamic>));
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderTracking>> refreshOrderStatus(
    String orderId,
  ) async {
    return getOrderTracking(orderId);
  }

  OrderTracking _parseTracking(String orderId, Map<String, dynamic> data) {
    final steps = (data['steps'] as List?)?.map((s) {
          final map = s as Map<String, dynamic>;
          final completed = map['completed'] as bool? ?? false;
          final completedAt = map['completedAt'] != null
              ? DateTime.tryParse(map['completedAt'] as String)
              : null;

          // Determine status based on completion
          DeliveryStatus status;
          if (completed) {
            status = DeliveryStatus.completed;
          } else if (completedAt == null &&
              _isNextAfterLastCompleted(data['steps'] as List, s)) {
            status = DeliveryStatus.active;
          } else {
            status = DeliveryStatus.pending;
          }

          return DeliveryStep(
            id: map['step'] as String? ?? '',
            label: map['step'] as String? ?? '',
            subtitle: map['subtitle'] as String?,
            status: status,
            completedAt: completedAt,
            iconName: _iconForStep(map['step'] as String? ?? ''),
          );
        }).toList() ??
        [];

    Courier? courier;
    if (data['courier'] != null) {
      final c = data['courier'] as Map<String, dynamic>;
      courier = Courier(
        id: c['id']?.toString() ?? '',
        name: c['name'] as String? ?? '',
        rating: (c['rating'] as num?)?.toDouble() ?? 0,
        vehicle: c['vehicle'] as String? ?? '',
        phone: c['phone'] as String? ?? '',
        photoUrl: c['photoUrl'] as String? ?? '',
      );
    }

    return OrderTracking(
      orderId: orderId,
      steps: steps,
      courier: courier,
      estimatedArrival: data['eta'] != null
          ? DateTime.tryParse(data['eta'] as String)
          : null,
    );
  }

  bool _isNextAfterLastCompleted(List steps, dynamic current) {
    int lastCompletedIdx = -1;
    for (int i = 0; i < steps.length; i++) {
      if ((steps[i] as Map<String, dynamic>)['completed'] == true) {
        lastCompletedIdx = i;
      }
    }
    final currentIdx = steps.indexOf(current);
    return currentIdx == lastCompletedIdx + 1;
  }

  String _iconForStep(String step) {
    final lower = step.toLowerCase();
    if (lower.contains('préparation') || lower.contains('reçue')) {
      return 'restaurant';
    }
    if (lower.contains('livraison') || lower.contains('route')) {
      return 'two_wheeler';
    }
    if (lower.contains('livrée') || lower.contains('delivered')) {
      return 'where_to_vote';
    }
    return 'check_circle';
  }
}
