import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/domain/usecases/get_current_user.dart';
import '../../../auth/domain/usecases/update_user_profile.dart';
import '../../../auth/domain/usecases/sign_out.dart';

// Events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String? name;
  final String? phone;
  final List<String>? addresses;

  const UpdateProfile({this.name, this.phone, this.addresses});

  @override
  List<Object?> get props => [name, phone, addresses];
}

class LogoutRequested extends ProfileEvent {}

// States
abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;
  const ProfileLoaded(this.user);
  @override
  List<Object?> get props => [user];
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
  @override
  List<Object?> get props => [message];
}

class ProfileNotAuthenticated extends ProfileState {}

class LogoutSuccess extends ProfileState {}

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetCurrentUser getCurrentUser;
  final UpdateUserProfile updateUserProfile;
  final SignOut signOut;

  ProfileBloc({
    required this.getCurrentUser,
    required this.updateUserProfile,
    required this.signOut,
  }) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await getCurrentUser();
    result.fold((failure) => emit(ProfileError(failure.message)), (user) {
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileNotAuthenticated());
      }
    });
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await updateUserProfile(
      UpdateUserProfileParams(
        name: event.name,
        phone: event.phone,
        addresses: event.addresses,
      ),
    );
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (user) => emit(ProfileLoaded(user)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await signOut();
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (_) => emit(LogoutSuccess()),
    );
  }
}
