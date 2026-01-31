import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/onboarding_page.dart';
import '../bloc/onboarding_bloc.dart';
import '../widgets/onboarding_page_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  final List<OnboardingPage> _pages = const [
    OnboardingPage(
      title: 'Simple, frais et\nsécurisé',
      description:
          'Une expérience d\'achat fluide pour vos produits frais au quotidien.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAgUVvi-7l09Mag6E4f_PsZhMo8FxXVJzWrerA-Dipj6GmAry_XlcolQ8h9i8DKziReWytYMzTzs0a2Vi_q1Nxbyjd6OM6UnUyQRGoVwGN74ZpQJj4GAU8_Eb4gPiLVVYENU4pCTfAM7TAyhv1cbImn7-4eP3bW2gd7DPTFqzPmDXaax1kLFvkqL-qA_3Mh81dcbfG6Zkzxp_4bnhGoalQTbTsWVDwqCreQkagvHbgRa9M9qJVyzhMX0AP67xlfp6X90XVvMcnIdw',
      badgeText: '100% Frais',
    ),
    OnboardingPage(
      title: 'Livraison\nrapide',
      description:
          'Recevez vos produits frais directement chez vous en un temps record.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAgUVvi-7l09Mag6E4f_PsZhMo8FxXVJzWrerA-Dipj6GmAry_XlcolQ8h9i8DKziReWytYMzTzs0a2Vi_q1Nxbyjd6OM6UnUyQRGoVwGN74ZpQJj4GAU8_Eb4gPiLVVYENU4pCTfAM7TAyhv1cbImn7-4eP3bW2gd7DPTFqzPmDXaax1kLFvkqL-qA_3Mh81dcbfG6Zkzxp_4bnhGoalQTbTsWVDwqCreQkagvHbgRa9M9qJVyzhMX0AP67xlfp6X90XVvMcnIdw',
      badgeText: 'Express',
    ),
    OnboardingPage(
      title: 'Qualité\ngarantie',
      description:
          'Des produits sélectionnés avec soin pour votre satisfaction.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAgUVvi-7l09Mag6E4f_PsZhMo8FxXVJzWrerA-Dipj6GmAry_XlcolQ8h9i8DKziReWytYMzTzs0a2Vi_q1Nxbyjd6OM6UnUyQRGoVwGN74ZpQJj4GAU8_Eb4gPiLVVYENU4pCTfAM7TAyhv1cbImn7-4eP3bW2gd7DPTFqzPmDXaax1kLFvkqL-qA_3Mh81dcbfG6Zkzxp_4bnhGoalQTbTsWVDwqCreQkagvHbgRa9M9qJVyzhMX0AP67xlfp6X90XVvMcnIdw',
      badgeText: 'Premium',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OnboardingBloc>(),
      child: BlocListener<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingCompleted) {
            // Navigate to home
            Navigator.of(context).pushReplacementNamed('/home');
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.backgroundDark,
          body: SafeArea(
            child: Column(
              children: [
                // Header with logo
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.restaurant,
                          color: AppColors.backgroundDark,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Boucherie Express',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Page View
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (index) {
                      context.read<OnboardingBloc>().add(PageChanged(index));
                    },
                    itemBuilder: (context, index) {
                      return OnboardingPageWidget(page: _pages[index]);
                    },
                  ),
                ),

                // Bottom section with indicators and button
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      // Page indicators
                      BlocBuilder<OnboardingBloc, OnboardingState>(
                        builder: (context, state) {
                          final currentPage = state is OnboardingInitial
                              ? state.currentPage
                              : 0;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _pages.length,
                              (index) => Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: index == currentPage ? 32 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: index == currentPage
                                      ? AppColors.primary
                                      : Colors.white24,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 32),

                      // Action button
                      BlocBuilder<OnboardingBloc, OnboardingState>(
                        builder: (context, state) {
                          final currentPage = state is OnboardingInitial
                              ? state.currentPage
                              : 0;
                          final isLastPage = currentPage == _pages.length - 1;

                          return SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () {
                                if (isLastPage) {
                                  context.read<OnboardingBloc>().add(
                                    CompleteOnboardingEvent(),
                                  );
                                } else {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.backgroundDark,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isLastPage
                                        ? 'Commencer mon achat'
                                        : 'Suivant',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
