import 'package:equatable/equatable.dart';

/// Onboarding page entity
class OnboardingPage extends Equatable {
  final String title;
  final String description;
  final String imageUrl;
  final String badgeText;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.badgeText,
  });

  @override
  List<Object?> get props => [title, description, imageUrl, badgeText];
}
