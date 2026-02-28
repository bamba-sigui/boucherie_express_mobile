import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../onboarding/domain/usecases/check_onboarding_status.dart';
import '../../../auth/domain/usecases/get_current_user.dart';

// Events
abstract class SplashEvent extends Equatable {
  const SplashEvent();
  @override
  List<Object?> get props => [];
}

class CheckInitialStatus extends SplashEvent {}

// States
abstract class SplashState extends Equatable {
  const SplashState();
  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class AuthenticatedState extends SplashState {}

class UnauthenticatedState extends SplashState {}

class OnboardingRequired extends SplashState {}

@injectable
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final CheckOnboardingStatus checkOnboardingStatus;
  final GetCurrentUser getCurrentUser;

  SplashBloc({
    required this.checkOnboardingStatus,
    required this.getCurrentUser,
  }) : super(SplashInitial()) {
    on<CheckInitialStatus>(_onCheckInitialStatus);
  }

  Future<void> _onCheckInitialStatus(
    CheckInitialStatus event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoading());

    // 1. Check Onboarding
    final onboardingResult = await checkOnboardingStatus();
    final bool isOnboardingCompleted = onboardingResult.fold(
      (_) => false,
      (completed) => completed,
    );

    if (!isOnboardingCompleted) {
      emit(OnboardingRequired());
      return;
    }

    // 2. Check Auth
    final authResult = await getCurrentUser();
    authResult.fold((_) => emit(UnauthenticatedState()), (user) {
      if (user != null) {
        emit(AuthenticatedState());
      } else {
        emit(UnauthenticatedState());
      }
    });
  }
}
