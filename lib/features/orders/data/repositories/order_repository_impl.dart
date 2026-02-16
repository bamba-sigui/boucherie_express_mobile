import 'package:dartz/dartz.dart' hide Order;
import 'package:injectable/injectable.dart' hide Order;
import '../../../../core/error/failures.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_local_datasource.dart';
import '../datasources/order_remote_datasource.dart';

@LazySingleton(as: OrderRepository)
class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final OrderLocalDataSource localDataSource;

  OrderRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Order>> createOrder(Order order) async {
    try {
      final orderModel = await remoteDataSource.createOrder(order);
      return Right(orderModel);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Order>>> getUserOrders(String userId) async {
    try {
      final orders = await remoteDataSource.getUserOrders(userId);
      return Right(orders);
    } catch (_) {
      // Fallback vers les données locales mock en développement
      try {
        final localOrders = await localDataSource.getOrders();
        return Right(localOrders);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, Order>> getOrderById(String orderId) async {
    try {
      final order = await remoteDataSource.getOrderById(orderId);
      return Right(order);
    } catch (_) {
      // Fallback vers les données locales mock en développement
      try {
        final localOrder = await localDataSource.getOrderById(orderId);
        if (localOrder != null) {
          return Right(localOrder);
        }
        return Left(ServerFailure('Commande introuvable'));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, void>> updateOrderStatus(
    String orderId,
    OrderStatus status,
  ) async {
    try {
      await remoteDataSource.updateOrderStatus(orderId, status);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
