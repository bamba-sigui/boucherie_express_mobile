import 'package:equatable/equatable.dart';
import '../../domain/entities/order.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class CreateOrderRequested extends OrderEvent {
  final Order order;

  const CreateOrderRequested(this.order);

  @override
  List<Object?> get props => [order];
}

class LoadUserOrders extends OrderEvent {}

class LoadOrderDetails extends OrderEvent {
  final String orderId;

  const LoadOrderDetails(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class UpdateOrderStatusRequested extends OrderEvent {
  final String orderId;
  final OrderStatus status;

  const UpdateOrderStatusRequested(this.orderId, this.status);

  @override
  List<Object?> get props => [orderId, status];
}
