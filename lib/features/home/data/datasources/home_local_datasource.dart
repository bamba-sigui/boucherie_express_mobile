import 'package:injectable/injectable.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/entities/home_category.dart';

/// Source de données locale (mock) pour la feature Home.
///
/// Fournit des données de démonstration fidèles au design Stitch.
/// Prête à être remplacée par une source remote (API / Firestore).
abstract class HomeLocalDataSource {
  Future<List<Product>> getProducts({String? categoryId});
  Future<List<HomeCategory>> getCategories();
  Future<void> toggleFavorite(String productId);
  Future<List<Product>> searchProducts(String query);
  Future<List<Product>> getFavoriteProducts();
  Set<String> get favoriteIds;
}

@LazySingleton(as: HomeLocalDataSource)
class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  /// Map des produits favoris (mock en mémoire).
  final Set<String> _favoriteIds = {};

  @override
  Set<String> get favoriteIds => _favoriteIds;

  /// Données mock correspondant au design Stitch.
  final List<Product> _mockProducts = const [
    // ── Poulet ──
    Product(
      id: 'p1',
      name: 'Poulet de Chair Entier',
      description: 'Nettoyé et Prêt à Cuire • 1.2kg',
      price: 3500,
      images: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDEdKWgo9iEKfTcq9I6hNvDw_LDHlJ0uFav8tDptZVa2oWR2a13WqXfKxtCf_QlKXgQJ1MjcbLt4YvXkzQTtUmYZHomZnFDwZL169jaoiz2t19LT7IxCy-vNvI4r77U3Xvpn1V1RJnmBPKSbkNsG2A_28X7TR-q8STsqCl5YbqQ6BPmKsqj0LsmGuDcJfK2mHC7MFKnM6jni8EgyfpWbm8PPouBd6DMH0kafQtHD-_7gIqUOBxhQfRfKMsC_Vf7FuN3EhxWFumC2g',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBjILed8FhgGgvVtlbG2qWPB6a5b8ByJkgzunk0ftNLsWVEFAz5luyq4t4BbHQM3tLOuhrUl4QDXa-GcuzxjRSEWn9bnNv-IoWgR4AkLLWEUzWQ2dZxoEz-59sXPzoyhS_26wlQcjJgP1rwI2h1Ij3yreDz-WWs2K-2-KFqp05Kitel5BXqOWFzaCwI_gvCvBhiPPtFbN5BvI-OE-UozWzQwSfvXXXKuShr-s3V2BIfCklCey__cOzmWaEqm-Y4tb-dYdh8Iek6EQ',
      ],
      category: 'poulet',
      farmName: 'Fermes Locales',
      unit: 'kg',
      stock: 25,
      preparationOptions: ['Entier', 'Découpé', 'Nettoyé'],
    ),
    Product(
      id: 'p2',
      name: 'Cuisses de Poulet',
      description: 'Lot de 6 pièces • 900g',
      price: 2800,
      images: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDEdKWgo9iEKfTcq9I6hNvDw_LDHlJ0uFav8tDptZVa2oWR2a13WqXfKxtCf_QlKXgQJ1MjcbLt4YvXkzQTtUmYZHomZnFDwZL169jaoiz2t19LT7IxCy-vNvI4r77U3Xvpn1V1RJnmBPKSbkNsG2A_28X7TR-q8STsqCl5YbqQ6BPmKsqj0LsmGuDcJfK2mHC7MFKnM6jni8EgyfpWbm8PPouBd6DMH0kafQtHD-_7gIqUOBxhQfRfKMsC_Vf7FuN3EhxWFumC2g',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBjILed8FhgGgvVtlbG2qWPB6a5b8ByJkgzunk0ftNLsWVEFAz5luyq4t4BbHQM3tLOuhrUl4QDXa-GcuzxjRSEWn9bnNv-IoWgR4AkLLWEUzWQ2dZxoEz-59sXPzoyhS_26wlQcjJgP1rwI2h1Ij3yreDz-WWs2K-2-KFqp05Kitel5BXqOWFzaCwI_gvCvBhiPPtFbN5BvI-OE-UozWzQwSfvXXXKuShr-s3V2BIfCklCey__cOzmWaEqm-Y4tb-dYdh8Iek6EQ',
      ],
      category: 'poulet',
      farmName: 'Fermes Locales',
      unit: 'kg',
      stock: 30,
      preparationOptions: ['Entier', 'Découpé'],
    ),

    // ── Bœuf ──
    Product(
      id: 'b1',
      name: 'Filet de Bœuf Premium',
      description: 'Origine: Fermes Locales • 1kg',
      price: 5500,
      images: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDXM2Istfc26EaBBsg-xZ0Kb4Dj8pnSaOjHMUlzgzns3n6hqDx6nMpI04g_Cpg-9dmNtuZUH00lM6Hz6rWOyhc7u2EB3IkUTiI_WB7g-FkqMuyx1nRDHSAYr2sIsJVT4BQdpNYG1LzIQw0wBrkvU76qpLqde40wphL9OgPW-pUgxN7LqfR0gswOxDSy-YVtyS-keueDzrhNCgcjYd8rPRple36wsuUxrVbN_qDQP5lF0pEf7IG4HSmAZOTAG7-xtijpjRzG2DeI0A',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDOAwXi2vjtxQc2hsmJh449eV9kgG0QaHa2p2vl1VODIUgFNT9tWbjW0Q8cuEBUlruZBv2bX2Y3TjgCsXxui9BJQUIXn6VrvlxWJ2jEWNDZVFaq9p18cgoXr0vSEKDqsp-eyoLB5tzOlyVy9jx085nbtrlV7TsQvRJNJNl7LgFu0FhncK9rWDbedsiGTu9d0H14yCsbz2_WXdQFyarjZ3q231Op3Un9-kJwaK3Pq204y5eAhL1kOwUkjWcTsYR0VGfnjhAeDjKlog',
      ],
      category: 'boeuf',
      farmName: 'Fermes Locales',
      unit: 'kg',
      stock: 15,
      preparationOptions: ['Entier', 'Tranché', 'Haché'],
    ),
    Product(
      id: 'b2',
      name: 'Entrecôte de Bœuf',
      description: 'Tendre et persillée • 500g',
      price: 4200,
      images: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDXM2Istfc26EaBBsg-xZ0Kb4Dj8pnSaOjHMUlzgzns3n6hqDx6nMpI04g_Cpg-9dmNtuZUH00lM6Hz6rWOyhc7u2EB3IkUTiI_WB7g-FkqMuyx1nRDHSAYr2sIsJVT4BQdpNYG1LzIQw0wBrkvU76qpLqde40wphL9OgPW-pUgxN7LqfR0gswOxDSy-YVtyS-keueDzrhNCgcjYd8rPRple36wsuUxrVbN_qDQP5lF0pEf7IG4HSmAZOTAG7-xtijpjRzG2DeI0A',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDOAwXi2vjtxQc2hsmJh449eV9kgG0QaHa2p2vl1VODIUgFNT9tWbjW0Q8cuEBUlruZBv2bX2Y3TjgCsXxui9BJQUIXn6VrvlxWJ2jEWNDZVFaq9p18cgoXr0vSEKDqsp-eyoLB5tzOlyVy9jx085nbtrlV7TsQvRJNJNl7LgFu0FhncK9rWDbedsiGTu9d0H14yCsbz2_WXdQFyarjZ3q231Op3Un9-kJwaK3Pq204y5eAhL1kOwUkjWcTsYR0VGfnjhAeDjKlog',
      ],
      category: 'boeuf',
      farmName: 'Fermes Locales',
      unit: 'kg',
      stock: 10,
      preparationOptions: ['Entier', 'Tranché'],
    ),

    // ── Poisson ──
    Product(
      id: 'f1',
      name: 'Carpe Fraîche Entière',
      description: 'Pêche du jour • 800g - 1kg',
      price: 4200,
      images: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCnYxp2oQXMeT1wABRx1ZhAPcLQe-M_ghfitMIqtqO27DfgOHDIUPm1l3TADXnKEbRTNO9UcwiiIwBkhAdtKNQIA2WjMJUC2vRVe1XIhUOOlLIbirys3P_cdNFybcADjKt3ziKShyyzuu4ohzTqVZWWJLm44C8D4VTf7bQTn5LKrGa5qPYcEjwkaBj396XX13cHjrkTDkrj0c09oMX06aRrul2ikGNEQH7g499LSdgqedCBxUTeWLwRgXW_wuUn3hQg8uUELRjfOQ',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCN82LqpySZALE_CpW2BNKYcwBEtUwVquaswnBZJ0QWwucs3Y2WwLC1_A1VbDtHNe8LRmNqT0VwIjSUNR_yZlB1EXaA_jDBnHA-6cZ9xsFEyj_YanXyqPfSePT_QCj3e1Gh3_EmsLungtDDC-WLAnkCnzEN3PTYl0gC4pKVUpIPaEy42n3P7hex2rCU7rWC54vMpAnDZ5sq7eEptzKSGrf4KAFMklOyogiu2ekiXIkSeM6l0_z24eATzisBu2_KjNQE9Jl7ddIP3Q',
      ],
      category: 'poisson',
      farmName: 'Pêche Locale',
      unit: 'kg',
      stock: 20,
      preparationOptions: ['Entier', 'Écaillé', 'Filet'],
    ),
    Product(
      id: 'f2',
      name: 'Tilapia Frais',
      description: 'Pêche artisanale • 600g',
      price: 3000,
      images: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCnYxp2oQXMeT1wABRx1ZhAPcLQe-M_ghfitMIqtqO27DfgOHDIUPm1l3TADXnKEbRTNO9UcwiiIwBkhAdtKNQIA2WjMJUC2vRVe1XIhUOOlLIbirys3P_cdNFybcADjKt3ziKShyyzuu4ohzTqVZWWJLm44C8D4VTf7bQTn5LKrGa5qPYcEjwkaBj396XX13cHjrkTDkrj0c09oMX06aRrul2ikGNEQH7g499LSdgqedCBxUTeWLwRgXW_wuUn3hQg8uUELRjfOQ',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCN82LqpySZALE_CpW2BNKYcwBEtUwVquaswnBZJ0QWwucs3Y2WwLC1_A1VbDtHNe8LRmNqT0VwIjSUNR_yZlB1EXaA_jDBnHA-6cZ9xsFEyj_YanXyqPfSePT_QCj3e1Gh3_EmsLungtDDC-WLAnkCnzEN3PTYl0gC4pKVUpIPaEy42n3P7hex2rCU7rWC54vMpAnDZ5sq7eEptzKSGrf4KAFMklOyogiu2ekiXIkSeM6l0_z24eATzisBu2_KjNQE9Jl7ddIP3Q',
      ],
      category: 'poisson',
      farmName: 'Pêche Locale',
      unit: 'kg',
      stock: 18,
      preparationOptions: ['Entier', 'Écaillé'],
    ),

    // ── Mouton ──
    Product(
      id: 'm1',
      name: 'Gigot de Mouton',
      description: 'Élevage traditionnel • 1.5kg',
      price: 6500,
      images: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDXM2Istfc26EaBBsg-xZ0Kb4Dj8pnSaOjHMUlzgzns3n6hqDx6nMpI04g_Cpg-9dmNtuZUH00lM6Hz6rWOyhc7u2EB3IkUTiI_WB7g-FkqMuyx1nRDHSAYr2sIsJVT4BQdpNYG1LzIQw0wBrkvU76qpLqde40wphL9OgPW-pUgxN7LqfR0gswOxDSy-YVtyS-keueDzrhNCgcjYd8rPRple36wsuUxrVbN_qDQP5lF0pEf7IG4HSmAZOTAG7-xtijpjRzG2DeI0A',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDOAwXi2vjtxQc2hsmJh449eV9kgG0QaHa2p2vl1VODIUgFNT9tWbjW0Q8cuEBUlruZBv2bX2Y3TjgCsXxui9BJQUIXn6VrvlxWJ2jEWNDZVFaq9p18cgoXr0vSEKDqsp-eyoLB5tzOlyVy9jx085nbtrlV7TsQvRJNJNl7LgFu0FhncK9rWDbedsiGTu9d0H14yCsbz2_WXdQFyarjZ3q231Op3Un9-kJwaK3Pq204y5eAhL1kOwUkjWcTsYR0VGfnjhAeDjKlog',
      ],
      category: 'mouton',
      farmName: 'Élevage Traditionnel',
      unit: 'kg',
      stock: 8,
      preparationOptions: ['Entier', 'Découpé'],
    ),
    Product(
      id: 'm2',
      name: 'Côtelettes de Mouton',
      description: 'Tendre et savoureux • 800g',
      price: 5000,
      images: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDXM2Istfc26EaBBsg-xZ0Kb4Dj8pnSaOjHMUlzgzns3n6hqDx6nMpI04g_Cpg-9dmNtuZUH00lM6Hz6rWOyhc7u2EB3IkUTiI_WB7g-FkqMuyx1nRDHSAYr2sIsJVT4BQdpNYG1LzIQw0wBrkvU76qpLqde40wphL9OgPW-pUgxN7LqfR0gswOxDSy-YVtyS-keueDzrhNCgcjYd8rPRple36wsuUxrVbN_qDQP5lF0pEf7IG4HSmAZOTAG7-xtijpjRzG2DeI0A',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDOAwXi2vjtxQc2hsmJh449eV9kgG0QaHa2p2vl1VODIUgFNT9tWbjW0Q8cuEBUlruZBv2bX2Y3TjgCsXxui9BJQUIXn6VrvlxWJ2jEWNDZVFaq9p18cgoXr0vSEKDqsp-eyoLB5tzOlyVy9jx085nbtrlV7TsQvRJNJNl7LgFu0FhncK9rWDbedsiGTu9d0H14yCsbz2_WXdQFyarjZ3q231Op3Un9-kJwaK3Pq204y5eAhL1kOwUkjWcTsYR0VGfnjhAeDjKlog',
      ],
      category: 'mouton',
      farmName: 'Élevage Traditionnel',
      unit: 'kg',
      stock: 12,
      preparationOptions: ['Entier', 'Découpé', 'Mariné'],
    ),
  ];

  static const List<HomeCategory> _mockCategories = [
    HomeCategory(id: 'tout', name: 'Tout', icon: '🏠'),
    HomeCategory(id: 'poulet', name: 'Poulet', icon: '🐔'),
    HomeCategory(id: 'poisson', name: 'Poisson', icon: '🐟'),
    HomeCategory(id: 'boeuf', name: 'Bœuf', icon: '🐄'),
    HomeCategory(id: 'mouton', name: 'Mouton', icon: '🐑'),
  ];

  @override
  Future<List<Product>> getProducts({String? categoryId}) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 400));

    if (categoryId == null || categoryId.isEmpty) {
      return _mockProducts;
    }
    return _mockProducts.where((p) => p.category == categoryId).toList();
  }

  @override
  Future<List<HomeCategory>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockCategories;
  }

  @override
  Future<void> toggleFavorite(String productId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lowerQuery = query.toLowerCase();
    return _mockProducts
        .where(
          (p) =>
              p.name.toLowerCase().contains(lowerQuery) ||
              p.description.toLowerCase().contains(lowerQuery) ||
              p.category.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  @override
  Future<List<Product>> getFavoriteProducts() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockProducts.where((p) => _favoriteIds.contains(p.id)).toList();
  }
}
