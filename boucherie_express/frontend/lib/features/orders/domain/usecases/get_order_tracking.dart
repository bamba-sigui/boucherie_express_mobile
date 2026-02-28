import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_tracking.dart';
import '../repositories/order_tracking_repository.dart';

/// Récupère les données de suivi d'une commande.
@lazySingleton
class GetOrderTracking
    implements UseCase<OrderTracking, GetOrderTrackingParams> {
  final OrderTrackingRepository repository;

  GetOrderTracking(this.repository);

  @override
  Future<Either<Failure, OrderTracking>> call(GetOrderTrackingParams params) {
    return repository.getOrderTracking(params.orderId);
  }
}

class GetOrderTrackingParams extends Equatable {
  final String orderId;

  const GetOrderTrackingParams({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}
