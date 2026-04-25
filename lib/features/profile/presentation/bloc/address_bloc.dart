import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/address.dart';
import '../../domain/usecases/delete_address.dart';
import '../../domain/usecases/get_addresses.dart';
import '../../domain/usecases/set_default_address.dart';

// ─── Events ──────────────────────────────────────────────────────────

abstract class AddressEvent extends Equatable {
  const AddressEvent();
  @override
  List<Object?> get props => [];
}

class LoadAddresses extends AddressEvent {}

class SelectDefaultAddress extends AddressEvent {
  final String addressId;
  const SelectDefaultAddress(this.addressId);
  @override
  List<Object?> get props => [addressId];
}

class RemoveAddress extends AddressEvent {
  final String addressId;
  const RemoveAddress(this.addressId);
  @override
  List<Object?> get props => [addressId];
}

// ─── States ──────────────────────────────────────────────────────────

abstract class AddressState extends Equatable {
  const AddressState();
  @override
  List<Object?> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressLoaded extends AddressState {
  final List<Address> addresses;
  const AddressLoaded(this.addresses);
  @override
  List<Object?> get props => [addresses];
}

class AddressError extends AddressState {
  final String message;
  const AddressError(this.message);
  @override
  List<Object?> get props => [message];
}

/// État temporaire émis après une suppression réussie.
class AddressDeleted extends AddressState {
  final List<Address> addresses;
  const AddressDeleted(this.addresses);
  @override
  List<Object?> get props => [addresses];
}

// ─── BLoC ────────────────────────────────────────────────────────────

@injectable
class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final GetAddresses getAddresses;
  final SetDefaultAddress setDefaultAddress;
  final DeleteAddress deleteAddress;

  AddressBloc({
    required this.getAddresses,
    required this.setDefaultAddress,
    required this.deleteAddress,
  }) : super(AddressInitial()) {
    on<LoadAddresses>(_onLoad);
    on<SelectDefaultAddress>(_onSelectDefault);
    on<RemoveAddress>(_onRemove);
  }

  Future<void> _onLoad(LoadAddresses event, Emitter<AddressState> emit) async {
    emit(AddressLoading());
    final result = await getAddresses();
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (addresses) => emit(AddressLoaded(addresses)),
    );
  }

  Future<void> _onSelectDefault(
    SelectDefaultAddress event,
    Emitter<AddressState> emit,
  ) async {
    // Pas de loading visible — update optimiste
    final result = await setDefaultAddress(event.addressId);
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (addresses) => emit(AddressLoaded(addresses)),
    );
  }

  Future<void> _onRemove(
    RemoveAddress event,
    Emitter<AddressState> emit,
  ) async {
    final result = await deleteAddress(event.addressId);
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (addresses) => emit(AddressDeleted(addresses)),
    );
  }
}
