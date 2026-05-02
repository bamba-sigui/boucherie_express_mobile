import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../features/auth/domain/usecases/get_current_user.dart';
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
  final GetCurrentUser getCurrentUser;

  OrderBloc({
    required this.createOrder,
    required this.getUserOrders,
    required this.getOrderById,
    required this.getCurrentUser,
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

    final userResult = await getCurrentUser();
    final userId = userResult.fold((_) => null, (user) => user?.id);

    if (userId == null) {
      emit(const OrderError('Utilisateur non connecté'));
      return;
    }

    final result = await getUserOrders(userId);

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
