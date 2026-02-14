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
import 'package:boucherie_express/features/products/presentation/screens/product_details_screen.dart';
import 'package:boucherie_express/features/products/domain/entities/product.dart';
import 'package:boucherie_express/features/orders/presentation/screens/checkout_screen.dart';
import 'package:boucherie_express/features/orders/domain/entities/order.dart';
import 'package:boucherie_express/features/orders/presentation/screens/orders_screen.dart';
import 'package:boucherie_express/features/orders/presentation/screens/order_details_screen.dart';

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
          return OrderDetailsScreen(order: order);
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
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page non trouvée: ${state.uri}'))),
  );
}
