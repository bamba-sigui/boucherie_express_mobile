import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/auth_session.dart';
import '../bloc/phone_auth_bloc.dart';
import '../widgets/auth_header.dart';
import '../widgets/phone_input_field.dart';

/// Écran de saisie du numéro de téléphone.
///
/// Design Stitch (boucherie_express_home_16) :
/// - Header : fermer (X), logo Boucherie Express, sous-titre
/// - Champ téléphone avec indicatif +225
/// - Bouton « Se connecter / S'inscrire » (primary, full-width)
/// - Footer : CGU & Politique de confidentialité
class PhoneInputScreen extends StatelessWidget {
  const PhoneInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<PhoneAuthBloc>(),
      child: const _PhoneInputView(),
    );
  }
}

class _PhoneInputView extends StatefulWidget {
  const _PhoneInputView();

  @override
  State<_PhoneInputView> createState() => _PhoneInputViewState();
}

class _PhoneInputViewState extends State<_PhoneInputView> {
  final _phoneController = TextEditingController();
  bool _isValid = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onPhoneChanged(String value) {
    setState(() {
      _isValid = PhoneInputField.isValid(value);
    });
  }

  String get _cleanPhone => _phoneController.text.replaceAll(' ', '');

  @override
  Widget build(BuildContext context) {
    return BlocListener<PhoneAuthBloc, PhoneAuthState>(
      listener: (context, state) {
        if (state is OtpSentSuccess) {
          // Navigue vers l'écran OTP en passant le téléphone
          context.push(
            '/otp-verification',
            extra: {
              'phone': state.phone,
              'formattedPhone': state.formattedPhone,
            },
          );
        } else if (state is PhoneAuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: SafeArea(
          child: Column(
            children: [
              // ── Top bar : close button ──
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.cardDark,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: .05),
                        ),
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white.withValues(alpha: .4),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),

              // ── Content ──
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),

                      // Logo header
                      const AuthHeader(subtitle: 'Connexion / Inscription'),

                      const SizedBox(height: 48),

                      // Phone input
                      PhoneInputField(
                        controller: _phoneController,
                        onChanged: _onPhoneChanged,
                      ),

                      const SizedBox(height: 32),

                      // Submit button
                      BlocBuilder<PhoneAuthBloc, PhoneAuthState>(
                        builder: (context, state) {
                          final isLoading = state is OtpRequesting;

                          return SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              child: ElevatedButton(
                                onPressed: (_isValid && !isLoading)
                                    ? () {
                                        // Validation domain
                                        if (!AuthSession.isValidPhone(
                                          _cleanPhone,
                                        )) {
                                          return;
                                        }
                                        context.read<PhoneAuthBloc>().add(
                                          SubmitPhoneNumber(phone: _cleanPhone),
                                        );
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.backgroundDark,
                                  disabledBackgroundColor: AppColors.primary
                                      .withValues(alpha: .3),
                                  disabledForegroundColor: AppColors
                                      .backgroundDark
                                      .withValues(alpha: .5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: AppColors.backgroundDark,
                                        ),
                                      )
                                    : const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Se connecter / S\'inscrire',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          );
                        },
                      ),

                      // OTP preview (disabled, design)
                      const SizedBox(height: 32),
                      Opacity(
                        opacity: 0.4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (i) {
                            return Padding(
                              padding: EdgeInsets.only(right: i < 3 ? 8 : 0),
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.cardDark,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: .05),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    '-',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Footer : legal ──
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: .2),
                      fontSize: 12,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(
                        text: 'En continuant, vous acceptez nos\n',
                      ),
                      TextSpan(
                        text: 'Conditions d\'utilisation',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .3),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: ' & '),
                      TextSpan(
                        text: 'Politique de confidentialité',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .3),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
