import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/create_order.dart';
import '../../domain/usecases/get_user_orders.dart';
import '../../domain/usecases/get_order_by_id.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';

@injectable
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final CreateOrder createOrder;
  final GetUserOrders getUserOrders;
  final GetOrderById getOrderById;

  OrderBloc({
    required this.createOrder,
    required this.getUserOrders,
    required this.getOrderById,
  }) : super(OrderInitial()) {
    on<CreateOrderRequested>(_onCreateOrder);
    on<LoadUserOrders>(_onLoadUserOrders);
    on<LoadOrderDetails>(_onLoadOrderDetails);
  }

  Future<void> _onCreateOrder(
    CreateOrderRequested event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());

    final result = await createOrder(event.order);

    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (order) => emit(OrderSuccess(createdOrder: order)),
    );
  }

  Future<void> _onLoadUserOrders(
    LoadUserOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());

    // In a real app, you'd get the userId from an AuthRepository
    final result = await getUserOrders('temp_user_id');

    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (orders) => emit(OrdersLoaded(orders)),
    );
  }

  Future<void> _onLoadOrderDetails(
    LoadOrderDetails event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());

    final result = await getOrderById(event.orderId);

    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (order) => emit(OrderDetailsLoaded(order)),
    );
  }
}
