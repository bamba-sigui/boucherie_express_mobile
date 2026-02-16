import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_tracking.dart';
import '../repositories/order_tracking_repository.dart';

/// Rafraîchit le statut de suivi (polling).
@lazySingleton
class RefreshOrderStatus
    implements UseCase<OrderTracking, RefreshOrderStatusParams> {
  final OrderTrackingRepository repository;

  RefreshOrderStatus(this.repository);

  @override
  Future<Either<Failure, OrderTracking>> call(RefreshOrderStatusParams params) {
    return repository.refreshOrderStatus(params.orderId);
  }
}

class RefreshOrderStatusParams extends Equatable {
  final String orderId;

  const RefreshOrderStatusParams({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}
