import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/complete_onboarding.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

@injectable
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final CompleteOnboarding completeOnboarding;

  OnboardingBloc(this.completeOnboarding) : super(const OnboardingInitial()) {
    on<PageChanged>(_onPageChanged);
    on<SkipOnboarding>(_onSkipOnboarding);
    on<CompleteOnboardingEvent>(_onCompleteOnboarding);
  }

  void _onPageChanged(PageChanged event, Emitter<OnboardingState> emit) {
    emit(OnboardingInitial(currentPage: event.pageIndex));
  }

  Future<void> _onSkipOnboarding(
    SkipOnboarding event,
    Emitter<OnboardingState> emit,
  ) async {
    await _completeOnboardingProcess(emit);
  }

  Future<void> _onCompleteOnboarding(
    CompleteOnboardingEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    await _completeOnboardingProcess(emit);
  }

  Future<void> _completeOnboardingProcess(Emitter<OnboardingState> emit) async {
    emit(OnboardingLoading());

    final result = await completeOnboarding();

    result.fold(
      (failure) => emit(OnboardingError(failure.message)),
      (_) => emit(OnboardingCompleted()),
    );
  }
}
