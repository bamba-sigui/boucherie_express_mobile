import 'package:dartz/dartz.dart' hide Order;
import 'package:injectable/injectable.dart' hide Order;
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

@injectable
class GetUserOrders implements UseCase<List<Order>, String> {
  final OrderRepository repository;

  GetUserOrders(this.repository);

  @override
  Future<Either<Failure, List<Order>>> call(String userId) async {
    return await repository.getUserOrders(userId);
  }
}
