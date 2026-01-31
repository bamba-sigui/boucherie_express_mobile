import 'package:equatable/equatable.dart';

/// Order status enum
enum OrderStatus {
  pending,
  confirmed,
  preparing,
  delivering,
  delivered,
  cancelled,
}

/// Payment method enum
enum PaymentMethod { cash, orangeMoney, moovMoney }

/// Order item entity (simplified for storage)
class OrderItem extends Equatable {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String option;

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.option,
  });

  @override
  List<Object?> get props => [productId, quantity, option];
}

/// Order entity
class Order extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String userPhone;
  final List<OrderItem> items;
  final double totalPrice; // items subtotal
  final double deliveryFee;
  final double totalAmount; // final total
  final String deliveryAddress;
  final OrderStatus status;
  final PaymentMethod paymentMethod;
  final String paymentStatus;
  final DateTime orderedAt;
  final String? note;

  const Order({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.items,
    required this.totalPrice,
    required this.deliveryFee,
    required this.totalAmount,
    required this.deliveryAddress,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderedAt,
    this.note,
  });

  @override
  List<Object?> get props => [id, userId, status, totalAmount];
}
