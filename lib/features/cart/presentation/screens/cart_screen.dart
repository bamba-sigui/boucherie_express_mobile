import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/cart_bloc.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/cart_summary.dart';
import '../widgets/checkout_bar.dart';
import '../widgets/free_delivery_progress.dart';

/// Cart screen matching the Stitch design at `my_shopping_cart`.
///
/// Structure:
/// 1. Blurred sticky header (back, title, item count badge)
/// 2. Scrollable list of [CartItemCard]
/// 3. Footer panel (rounded-t-[2.5rem]):
///    – [FreeDeliveryProgress]
///    – [CartSummary]
///    – [CheckoutBar]
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure cart is loaded when the screen opens
    context.read<CartBloc>().add(LoadCart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is CartError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: AppColors.error),
              ),
            );
          }

          if (state is CartLoaded) {
            if (state.cart.isEmpty) {
              return _buildEmptyCart(context);
            }
            return _buildCartContent(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  // ── Empty state ──────────────────────────────────────────────────────

  Widget _buildEmptyCart(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _CartHeader(itemCount: 0),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.white.withValues(alpha: .15),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Votre panier est vide',
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ajoutez des produits pour commencer',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: .4),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: 220,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => context.pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.backgroundDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: const Text(
                        'Continuer mes achats',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Cart with items ─────────────────────────────────────────────────

  Widget _buildCartContent(BuildContext context, CartLoaded state) {
    final cart = state.cart;

    return Column(
      children: [
        // ── Header ──
        SafeArea(bottom: false, child: _CartHeader(itemCount: cart.totalItems)),

        // ── Items list ──
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CartItemCard(
                  item: item,
                  onQuantityChanged: (newQty) {
                    context.read<CartBloc>().add(
                      UpdateCartItemQuantity(
                        productId: item.productId,
                        quantity: newQty,
                      ),
                    );
                  },
                  onRemove: () {
                    context.read<CartBloc>().add(
                      RemoveProductFromCart(item.productId),
                    );
                  },
                ),
              );
            },
          ),
        ),

        // ── Footer panel ──
        _CartFooter(cart: cart, onCheckout: () => context.push('/checkout')),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HEADER
// ═══════════════════════════════════════════════════════════════════════════

class _CartHeader extends StatelessWidget {
  final int itemCount;

  const _CartHeader({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.backgroundDark.withValues(alpha: .9),
            border: Border(
              bottom: BorderSide(color: Colors.white.withValues(alpha: .05)),
            ),
          ),
          child: Row(
            children: [
              // Back button
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .05),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),

              // Title
              const Expanded(
                child: Text(
                  'Mon Panier',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Item count badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '$itemCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// FOOTER
// ═══════════════════════════════════════════════════════════════════════════

class _CartFooter extends StatelessWidget {
  final dynamic cart; // Cart entity
  final VoidCallback onCheckout;

  const _CartFooter({required this.cart, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: 24 + bottomPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: .05)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .4),
            blurRadius: 40,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Free delivery progress
          FreeDeliveryProgress(
            progress: cart.freeDeliveryProgress,
            remaining: cart.remainingForFreeDelivery,
            hasFreeDelivery: cart.hasFreeDelivery,
          ),
          const SizedBox(height: 24),

          // Summary
          CartSummary(cart: cart),
          const SizedBox(height: 32),

          // Checkout button
          CheckoutBar(onCheckout: onCheckout),
        ],
      ),
    );
  }
}
