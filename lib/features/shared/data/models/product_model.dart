import 'package:boucherie_express/features/shared/domain/entities/product.dart';

/// Product model for data layer
class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    super.oldPrice,
    required super.images,
    super.videoUrl,
    required super.category,
    super.preparationOptions,
    super.isBio,
    super.isFresh,
    super.farmName,
    super.stock,
    super.unit,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final cat = json['category'];
    return ProductModel(
      id: json['id'].toString(),
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      oldPrice: json['oldPrice'] != null
          ? (json['oldPrice'] as num).toDouble()
          : null,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      videoUrl: json['videoUrl'] as String?,
      category: cat is Map
          ? (cat as Map<String, dynamic>)['name'] as String? ?? ''
          : json['categoryId']?.toString() ?? '',
      preparationOptions:
          (json['preparationOptions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          ['Entier'],
      isBio: json['isBio'] as bool? ?? false,
      isFresh: json['isFresh'] as bool? ?? true,
      farmName: json['farmName'] as String? ?? 'Ferme Locale',
      stock: json['stock'] as int? ?? 0,
      unit: json['unit'] as String? ?? 'unité',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'oldPrice': oldPrice,
      'images': images,
      'videoUrl': videoUrl,
      'category': category,
      'preparationOptions': preparationOptions,
      'isBio': isBio,
      'isFresh': isFresh,
      'farmName': farmName,
      'stock': stock,
      'unit': unit,
    };
  }
}
