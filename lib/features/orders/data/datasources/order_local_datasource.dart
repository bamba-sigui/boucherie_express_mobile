import 'package:injectable/injectable.dart' hide Order;
import '../../domain/entities/order.dart';
import '../models/order_model.dart';

/// Source de données locale pour les commandes.
///
/// Fournit des données mock réalistes pour le développement.
/// Sera remplacé par l'API REST en production — le [OrderRepository]
/// basculera alors sur la datasource distante uniquement.
abstract class OrderLocalDataSource {
  /// Retourne la liste des commandes mock.
  Future<List<OrderModel>> getOrders();

  /// Retourne une commande par son ID.
  Future<OrderModel?> getOrderById(String orderId);
}

@LazySingleton(as: OrderLocalDataSource)
class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  @override
  Future<OrderModel?> getOrderById(String orderId) async {
    final orders = await getOrders();
    try {
      return orders.firstWhere((o) => o.id == orderId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    // Simule une latence réseau
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      OrderModel(
        id: 'BE-1245',
        userId: 'mock_user',
        userName: 'Amadou Diallo',
        userPhone: '+223 70 00 00 01',
        items: const [
          OrderItem(
            productId: 'p1',
            productName: 'Côtelettes d\'Agneau',
            price: 5500,
            quantity: 1,
            option: 'Fraîches',
            imageUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDXM2Istfc26EaBBsg-xZ0Kb4Dj8pnSaOjHMUlzgzns3n6hqDx6nMpI04g_Cpg-9dmNtuZUH00lM6Hz6rWOyhc7u2EB3IkUTiI_WB7g-FkqMuyx1nRDHSAYr2sIsJVT4BQdpNYG1LzIQw0wBrkvU76qpLqde40wphL9OgPW-pUgxN7LqfR0gswOxDSy-YVtyS-keueDzrhNCgcjYd8rPRple36wsuUxrVbN_qDQP5lF0pEf7IG4HSmAZOTAG7-xtijpjRzG2DeI0A',
          ),
          OrderItem(
            productId: 'p2',
            productName: 'Filet de Bœuf Premium',
            price: 4500,
            quantity: 1,
            option: 'Épais',
            imageUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDEdKWgo9iEKfTcq9I6hNvDw_LDHlJ0uFav8tDptZVa2oWR2a13WqXfKxtCf_QlKXgQJ1MjcbLt4YvXkzQTtUmYZHomZnFDwZL169jaoiz2t19LT7IxCy-vNvI4r77U3Xvpn1V1RJnmBPKSbkNsG2A_28X7TR-q8STsqCl5YbqQ6BPmKsqj0LsmGuDcJfK2mHC7MFKnM6jni8EgyfpWbm8PPouBd6DMH0kafQtHD-_7gIqUOBxhQfRfKMsC_Vf7FuN3EhxWFumC2g',
          ),
          OrderItem(
            productId: 'p3',
            productName: 'Poulet Fermier Entier',
            price: 2500,
            quantity: 1,
            option: 'Découpé',
            imageUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCnYxp2oQXMeT1wABRx1ZhAPcLQe-M_ghfitMIqtqO27DfgOHDIUPm1l3TADXnKEbRTNO9UcwiiIwBkhAdtKNQIA2WjMJUC2vRVe1XIhUOOlLIbirys3P_cdNFybcADjKt3ziKShyyzuu4ohzTqVZWWJLm44C8D4VTf7bQTn5LKrGa5qPYcEjwkaBj396XX13cHjrkTDkrj0c09oMX06aRrul2ikGNEQH7g499LSdgqedCBxUTeWLwRgXW_wuUn3hQg8uUELRjfOQ',
          ),
        ],
        totalPrice: 12500,
        deliveryFee: 0,
        totalAmount: 12500,
        deliveryAddress: 'Bamako, Hamdallaye ACI 2000',
        status: OrderStatus.preparing,
        paymentMethod: PaymentMethod.cash,
        paymentStatus: 'pending',
        orderedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      OrderModel(
        id: 'BE-1239',
        userId: 'mock_user',
        userName: 'Amadou Diallo',
        userPhone: '+223 70 00 00 01',
        items: const [
          OrderItem(
            productId: 'p4',
            productName: 'Merguez Maison',
            price: 4200,
            quantity: 1,
            option: 'Épicées',
            imageUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCnYxp2oQXMeT1wABRx1ZhAPcLQe-M_ghfitMIqtqO27DfgOHDIUPm1l3TADXnKEbRTNO9UcwiiIwBkhAdtKNQIA2WjMJUC2vRVe1XIhUOOlLIbirys3P_cdNFybcADjKt3ziKShyyzuu4ohzTqVZWWJLm44C8D4VTf7bQTn5LKrGa5qPYcEjwkaBj396XX13cHjrkTDkrj0c09oMX06aRrul2ikGNEQH7g499LSdgqedCBxUTeWLwRgXW_wuUn3hQg8uUELRjfOQ',
          ),
        ],
        totalPrice: 4200,
        deliveryFee: 0,
        totalAmount: 4200,
        deliveryAddress: 'Bamako, Badalabougou',
        status: OrderStatus.delivering,
        paymentMethod: PaymentMethod.orangeMoney,
        paymentStatus: 'paid',
        orderedAt: DateTime.now().subtract(const Duration(hours: 26)),
      ),
      OrderModel(
        id: 'BE-1234',
        userId: 'mock_user',
        userName: 'Amadou Diallo',
        userPhone: '+223 70 00 00 01',
        items: const [
          OrderItem(
            productId: 'p5',
            productName: 'Entrecôte de Bœuf',
            price: 5000,
            quantity: 1,
            option: 'Marinée',
            imageUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDOAwXi2vjtxQc2hsmJh449eV9kgG0QaHa2p2vl1VODIUgFNT9tWbjW0Q8cuEBUlruZBv2bX2Y3TjgCsXxui9BJQUIXn6VrvlxWJ2jEWNDZVFaq9p18cgoXr0vSEKDqsp-eyoLB5tzOlyVy9jx085nbtrlV7TsQvRJNJNl7LgFu0FhncK9rWDbedsiGTu9d0H14yCsbz2_WXdQFyarjZ3q231Op3Un9-kJwaK3Pq204y5eAhL1kOwUkjWcTsYR0VGfnjhAeDjKlog',
          ),
          OrderItem(
            productId: 'p6',
            productName: 'Saucisses de Bœuf',
            price: 3000,
            quantity: 1,
            option: 'Nature',
            imageUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuBjILed8FhgGgvVtlbG2qWPB6a5b8ByJkgzunk0ftNLsWVEFAz5luyq4t4BbHQM3tLOuhrUl4QDXa-GcuzxjRSEWn9bnNv-IoWgR4AkLLWEUzWQ2dZxoEz-59sXPzoyhS_26wlQcjJgP1rwI2h1Ij3yreDz-WWs2K-2-KFqp05Kitel5BXqOWFzaCwI_gvCvBhiPPtFbN5BvI-OE-UozWzQwSfvXXXKuShr-s3V2BIfCklCey__cOzmWaEqm-Y4tb-dYdh8Iek6EQ',
          ),
        ],
        totalPrice: 8000,
        deliveryFee: 0,
        totalAmount: 8000,
        deliveryAddress: 'Bamako, Magnambougou',
        status: OrderStatus.delivered,
        paymentMethod: PaymentMethod.cash,
        paymentStatus: 'paid',
        orderedAt: DateTime(2023, 10, 12, 18, 45),
      ),
      OrderModel(
        id: 'BE-1221',
        userId: 'mock_user',
        userName: 'Amadou Diallo',
        userPhone: '+223 70 00 00 01',
        items: const [
          OrderItem(
            productId: 'p7',
            productName: 'Gigot d\'Agneau',
            price: 15400,
            quantity: 1,
            option: 'Désossé',
            imageUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCN82LqpySZALE_CpW2BNKYcwBEtUwVquaswnBZJ0QWwucs3Y2WwLC1_A1VbDtHNe8LRmNqT0VwIjSUNR_yZlB1EXaA_jDBnHA-6cZ9xsFEyj_YanXyqPfSePT_QCj3e1Gh3_EmsLungtDDC-WLAnkCnzEN3PTYl0gC4pKVUpIPaEy42n3P7hex2rCU7rWC54vMpAnDZ5sq7eEptzKSGrf4KAFMklOyogiu2ekiXIkSeM6l0_z24eATzisBu2_KjNQE9Jl7ddIP3Q',
          ),
        ],
        totalPrice: 15400,
        deliveryFee: 0,
        totalAmount: 15400,
        deliveryAddress: 'Bamako, Sotuba ACI',
        status: OrderStatus.delivered,
        paymentMethod: PaymentMethod.moovMoney,
        paymentStatus: 'paid',
        orderedAt: DateTime(2023, 10, 8, 9, 20),
      ),
    ];
  }
}
