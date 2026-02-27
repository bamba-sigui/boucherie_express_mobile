import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/order_tracking.dart';
import '../../domain/usecases/get_order_tracking.dart';
import '../../domain/usecases/refresh_order_status.dart';

part 'order_tracking_event.dart';
part 'order_tracking_state.dart';

/// BLoC de suivi de commande.
///
/// Gère le chargement initial et le rafraîchissement (polling 30 s).
@injectable
class OrderTrackingBloc extends Bloc<OrderTrackingEvent, OrderTrackingState> {
  final GetOrderTracking getOrderTracking;
  final RefreshOrderStatus refreshOrderStatus;

  String? _currentOrderId;
  Timer? _pollingTimer;

  OrderTrackingBloc(this.getOrderTracking, this.refreshOrderStatus)
    : super(OrderTrackingInitial()) {
    on<LoadOrderTracking>(_onLoad);
    on<RefreshOrderTracking>(_onRefresh);
  }

  // ── Handlers ──────────────────────────────────────────────────────────

  Future<void> _onLoad(
    LoadOrderTracking event,
    Emitter<OrderTrackingState> emit,
  ) async {
    _currentOrderId = event.orderId;
    emit(OrderTrackingLoading());

    final result = await getOrderTracking(
      GetOrderTrackingParams(orderId: event.orderId),
    );

    result.fold(
      (failure) => emit(OrderTrackingError(message: failure.message)),
      (tracking) {
        emit(OrderTrackingLoaded(tracking: tracking));
        _startPolling();
      },
    );
  }

  Future<void> _onRefresh(
    RefreshOrderTracking event,
    Emitter<OrderTrackingState> emit,
  ) async {
    final orderId = _currentOrderId;
    if (orderId == null) return;

    final result = await refreshOrderStatus(
      RefreshOrderStatusParams(orderId: orderId),
    );

    result.fold(
      // On ne casse pas l'affichage en cas d'erreur de refresh
      (_) {},
      (tracking) => emit(OrderTrackingLoaded(tracking: tracking)),
    );
  }

  // ── Polling ───────────────────────────────────────────────────────────

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => add(const RefreshOrderTracking()),
    );
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}
