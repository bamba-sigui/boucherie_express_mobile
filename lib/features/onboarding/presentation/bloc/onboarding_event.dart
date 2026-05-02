part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class SkipOnboarding extends OnboardingEvent {}

class CompleteOnboardingEvent extends OnboardingEvent {}
