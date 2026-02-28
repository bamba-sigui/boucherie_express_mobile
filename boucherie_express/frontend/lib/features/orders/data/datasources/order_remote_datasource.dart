import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:injectable/injectable.dart' hide Order;
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/order.dart';
import '../models/order_model.dart';

/// Remote data source for orders
abstract class OrderRemoteDataSource {
  Future<OrderModel> createOrder(Order order);
  Future<List<OrderModel>> getUserOrders(String userId);
  Future<OrderModel> getOrderById(String orderId);
  Future<void> updateOrderStatus(String orderId, OrderStatus status);
  Stream<OrderModel> watchOrder(String orderId);
}

@LazySingleton(as: OrderRemoteDataSource)
class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final FirebaseFirestore firestore;

  OrderRemoteDataSourceImpl(this.firestore);

  @override
  Future<OrderModel> createOrder(Order order) async {
    try {
      final docRef = firestore.collection(AppConstants.collectionOrders).doc();
      final orderModel = OrderModel(
        id: docRef.id,
        userId: order.userId,
        userName: order.userName,
        userPhone: order.userPhone,
        items: order.items,
        totalPrice: order.totalPrice,
        deliveryFee: order.deliveryFee,
        totalAmount: order.totalAmount,
        deliveryAddress: order.deliveryAddress,
        status: order.status,
        paymentMethod: order.paymentMethod,
        paymentStatus: order.paymentStatus,
        orderedAt: order.orderedAt,
        note: order.note,
      );

      await docRef.set(orderModel.toJson());
      return orderModel;
    } catch (e) {
      throw ServerException('Erreur lors de la création de la commande');
    }
  }

  @override
  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      final snapshot = await firestore
          .collection(AppConstants.collectionOrders)
          .where('userId', isEqualTo: userId)
          .orderBy('orderedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => OrderModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw ServerException('Erreur lors de la récupération des commandes');
    }
  }

  @override
  Future<OrderModel> getOrderById(String orderId) async {
    try {
      final doc = await firestore
          .collection(AppConstants.collectionOrders)
          .doc(orderId)
          .get();

      if (!doc.exists) {
        throw NotFoundException('Commande introuvable');
      }

      return OrderModel.fromJson({...doc.data()!, 'id': doc.id});
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw ServerException('Erreur lors de la récupération de la commande');
    }
  }

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await firestore
          .collection(AppConstants.collectionOrders)
          .doc(orderId)
          .update({'status': status.name});
    } catch (e) {
      throw ServerException('Erreur lors de la mise à jour du statut');
    }
  }

  @override
  Stream<OrderModel> watchOrder(String orderId) {
    return firestore
        .collection(AppConstants.collectionOrders)
        .doc(orderId)
        .snapshots()
        .map((doc) {
          if (!doc.exists) {
            throw NotFoundException('Commande introuvable');
          }
          return OrderModel.fromJson({...doc.data()!, 'id': doc.id});
        });
  }
}
