import 'package:hive/hive.dart';
import '../../domain/entities/cart.dart';
import '../../../shared/data/models/product_model.dart';

part 'cart_item_model.g.dart';

@HiveType(typeId: 0)
class CartItemModel extends HiveObject {
  @HiveField(0)
  final Map<String, dynamic> productJson;

  @HiveField(1)
  final int quantity;

  @HiveField(2)
  final String preparationOption;

  CartItemModel({
    required this.productJson,
    required this.quantity,
    required this.preparationOption,
  });

  factory CartItemModel.fromEntity(CartItem item) {
    return CartItemModel(
      productJson: ProductModel(
        id: item.product.id,
        name: item.product.name,
        description: item.product.description,
        price: item.product.price,
        oldPrice: item.product.oldPrice,
        images: item.product.images,
        videoUrl: item.product.videoUrl,
        category: item.product.category,
        preparationOptions: item.product.preparationOptions,
        isBio: item.product.isBio,
        isFresh: item.product.isFresh,
        farmName: item.product.farmName,
        stock: item.product.stock,
        unit: item.product.unit,
      ).toJson(),
      quantity: item.quantity,
      preparationOption: item.preparationOption,
    );
  }

  CartItem toEntity() {
    return CartItem(
      product: ProductModel.fromJson(productJson),
      quantity: quantity,
      preparationOption: preparationOption,
    );
  }
}
