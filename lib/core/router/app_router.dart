import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:boucherie_express/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:boucherie_express/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:boucherie_express/features/products/presentation/screens/main_screen.dart';
import 'package:boucherie_express/features/cart/presentation/screens/cart_screen.dart';
import 'package:boucherie_express/features/payment/presentation/screens/payment_method_screen.dart';
import 'package:boucherie_express/features/favorites/presentation/pages/favorites_page.dart';
import 'package:boucherie_express/features/auth/presentation/screens/login_screen.dart';
import 'package:boucherie_express/features/auth/presentation/screens/signup_screen.dart';
import 'package:boucherie_express/features/auth/presentation/screens/phone_input_screen.dart';
import 'package:boucherie_express/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:boucherie_express/features/products/presentation/screens/product_details_screen.dart';
import 'package:boucherie_express/features/products/domain/entities/product.dart';
import 'package:boucherie_express/features/checkout/presentation/screens/checkout_screen.dart';
import 'package:boucherie_express/features/orders/domain/entities/order.dart';
import 'package:boucherie_express/features/orders/presentation/screens/orders_screen.dart';
import 'package:boucherie_express/features/orders/presentation/pages/order_details_page.dart';
import 'package:boucherie_express/features/order_tracking/presentation/screens/order_tracking_screen.dart';
import 'package:boucherie_express/features/profile/presentation/screens/personal_info_screen.dart';
import 'package:boucherie_express/features/profile/presentation/screens/addresses_screen.dart';
import 'package:boucherie_express/features/profile/presentation/screens/payment_methods_screen.dart';
import 'package:boucherie_express/features/profile/presentation/pages/support_page.dart';

/// App router configuration
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/details',
        name: 'details',
        builder: (context, state) {
          final product = state.extra as Product;
          return ProductDetailsScreen(product: product);
        },
      ),
      GoRoute(
        path: '/checkout',
        name: 'checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/orders',
        name: 'orders',
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        path: '/order-details',
        name: 'order-details',
        builder: (context, state) {
          final order = state.extra as Order;
          return OrderDetailsPage(order: order);
        },
      ),
      GoRoute(
        path: '/payment',
        name: 'payment',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return PaymentMethodScreen(checkoutData: data);
        },
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoritesPage(),
      ),
      GoRoute(
        path: '/order-tracking',
        name: 'order-tracking',
        builder: (context, state) {
          final orderId = state.extra as String? ?? '';
          return OrderTrackingScreen(orderId: orderId);
        },
      ),
      GoRoute(
        path: '/personal-info',
        name: 'personal-info',
        builder: (context, state) => const PersonalInfoScreen(),
      ),
      GoRoute(
        path: '/addresses',
        name: 'addresses',
        builder: (context, state) => const AddressesScreen(),
      ),
      GoRoute(
        path: '/payment-methods',
        name: 'payment-methods',
        builder: (context, state) => const PaymentMethodsScreen(),
      ),
      GoRoute(
        path: '/support',
        name: 'support',
        builder: (context, state) => const SupportPage(),
      ),
      GoRoute(
        path: '/phone-auth',
        name: 'phone-auth',
        builder: (context, state) => const PhoneInputScreen(),
      ),
      GoRoute(
        path: '/otp-verification',
        name: 'otp-verification',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return OtpVerificationScreen(
            phone: data['phone'] as String,
            formattedPhone: data['formattedPhone'] as String,
          );
        },
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page non trouvée: ${state.uri}'))),
  );
}
