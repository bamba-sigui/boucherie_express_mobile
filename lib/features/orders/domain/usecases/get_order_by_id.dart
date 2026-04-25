import 'package:dartz/dartz.dart' hide Order;
import 'package:injectable/injectable.dart' hide Order;
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

@injectable
class GetOrderById implements UseCase<Order, String> {
  final OrderRepository repository;

  GetOrderById(this.repository);

  @override
  Future<Either<Failure, Order>> call(String orderId) async {
    return await repository.getOrderById(orderId);
  }
}
