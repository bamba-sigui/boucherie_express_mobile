/// App-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Boucherie Express';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyCartItems = 'cart_items';
  static const String keyFavorites = 'favorites';

  // Hive Box Names
  static const String hiveBoxCart = 'cart_box';
  static const String hiveBoxSettings = 'settings_box';

  // Firebase Collections
  static const String collectionUsers = 'users';
  static const String collectionProducts = 'products';
  static const String collectionCategories = 'categories';
  static const String collectionOrders = 'orders';
  static const String collectionFavorites = 'favorites';

  // Delivery
  static const double deliveryFee = 2000.0; // FCFA
  static const double freeDeliveryThreshold = 20000.0; // FCFA

  // Pagination
  static const int productsPerPage = 20;
  static const int ordersPerPage = 10;

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration cacheTimeout = Duration(hours: 1);

  // Image Placeholders
  static const String productPlaceholder =
      'assets/images/product_placeholder.png';
  static const String userPlaceholder = 'assets/images/user_placeholder.png';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Validation
  static const int minPasswordLength = 6;
  static const int maxProductQuantity = 99;

  // Currency
  static const String currency = 'FCFA';
  static const String currencySymbol = 'FCFA';
}
