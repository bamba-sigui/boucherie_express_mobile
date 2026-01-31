import 'package:dartz/dartz.dart' hide Order;
import '../../../../core/error/failures.dart';
import '../entities/order.dart';

abstract class OrderRepository {
  Future<Either<Failure, Order>> createOrder(Order order);
  Future<Either<Failure, List<Order>>> getUserOrders(String userId);
  Future<Either<Failure, Order>> getOrderById(String orderId);
  Future<Either<Failure, void>> updateOrderStatus(
    String orderId,
    OrderStatus status,
  );
}
