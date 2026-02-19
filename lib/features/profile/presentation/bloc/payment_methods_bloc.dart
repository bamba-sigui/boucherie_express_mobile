import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/payment_method.dart';
import '../../domain/usecases/get_payment_methods.dart';
import '../../domain/usecases/set_default_payment_method.dart';
import '../../domain/usecases/remove_payment_method.dart';

// ─── Events ──────────────────────────────────────────────────────────

abstract class PaymentMethodsEvent extends Equatable {
  const PaymentMethodsEvent();
  @override
  List<Object?> get props => [];
}

class LoadPaymentMethods extends PaymentMethodsEvent {}

class SelectDefaultMethod extends PaymentMethodsEvent {
  final String methodId;
  const SelectDefaultMethod(this.methodId);
  @override
  List<Object?> get props => [methodId];
}

class RemoveMethod extends PaymentMethodsEvent {
  final String methodId;
  const RemoveMethod(this.methodId);
  @override
  List<Object?> get props => [methodId];
}

// ─── States ──────────────────────────────────────────────────────────

abstract class PaymentMethodsState extends Equatable {
  const PaymentMethodsState();
  @override
  List<Object?> get props => [];
}

class PaymentMethodsInitial extends PaymentMethodsState {}

class PaymentMethodsLoading extends PaymentMethodsState {}

class PaymentMethodsLoaded extends PaymentMethodsState {
  final List<PaymentMethod> methods;
  const PaymentMethodsLoaded(this.methods);

  List<PaymentMethod> get wallets => methods
      .where((m) =>
          m.type == PaymentMethodType.wave ||
          m.type == PaymentMethodType.orangeMoney ||
          m.type == PaymentMethodType.momo)
      .toList();

  PaymentMethod? get cashMethod =>
      methods.cast<PaymentMethod?>().firstWhere(
            (m) => m!.type == PaymentMethodType.cash,
            orElse: () => null,
          );

  List<PaymentMethod> get cards =>
      methods.where((m) => m.type == PaymentMethodType.card).toList();

  @override
  List<Object?> get props => [methods];
}

class PaymentMethodsError extends PaymentMethodsState {
  final String message;
  const PaymentMethodsError(this.message);
  @override
  List<Object?> get props => [message];
}

// ─── BLoC ────────────────────────────────────────────────────────────

@injectable
class PaymentMethodsBloc
    extends Bloc<PaymentMethodsEvent, PaymentMethodsState> {
  final GetPaymentMethods getPaymentMethods;
  final SetDefaultPaymentMethod setDefaultPaymentMethod;
  final RemovePaymentMethod removePaymentMethod;

  PaymentMethodsBloc({
    required this.getPaymentMethods,
    required this.setDefaultPaymentMethod,
    required this.removePaymentMethod,
  }) : super(PaymentMethodsInitial()) {
    on<LoadPaymentMethods>(_onLoad);
    on<SelectDefaultMethod>(_onSelectDefault);
    on<RemoveMethod>(_onRemove);
  }

  Future<void> _onLoad(
    LoadPaymentMethods event,
    Emitter<PaymentMethodsState> emit,
  ) async {
    emit(PaymentMethodsLoading());
    final result = await getPaymentMethods();
    result.fold(
      (failure) => emit(PaymentMethodsError(failure.message)),
      (methods) => emit(PaymentMethodsLoaded(methods)),
    );
  }

  Future<void> _onSelectDefault(
    SelectDefaultMethod event,
    Emitter<PaymentMethodsState> emit,
  ) async {
    final result = await setDefaultPaymentMethod(event.methodId);
    result.fold(
      (failure) => emit(PaymentMethodsError(failure.message)),
      (methods) => emit(PaymentMethodsLoaded(methods)),
    );
  }

  Future<void> _onRemove(
    RemoveMethod event,
    Emitter<PaymentMethodsState> emit,
  ) async {
    final result = await removePaymentMethod(event.methodId);
    result.fold(
      (failure) => emit(PaymentMethodsError(failure.message)),
      (methods) => emit(PaymentMethodsLoaded(methods)),
    );
  }
}
