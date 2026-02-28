import 'package:dartz/dartz.dart' hide Order;
import 'package:injectable/injectable.dart' hide Order;
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

@injectable
class CreateOrder implements UseCase<Order, Order> {
  final OrderRepository repository;

  CreateOrder(this.repository);

  @override
  Future<Either<Failure, Order>> call(Order order) async {
    return await repository.createOrder(order);
  }
}
