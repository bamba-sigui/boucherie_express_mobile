/// API endpoint constants for the Flask backend.
class ApiConstants {
  ApiConstants._();

  // ── Base URL ───────────────────────────────────────────────────────────
  // Android emulator: 10.0.2.2 | iOS simulator: localhost | Device: LAN IP
  static const String baseUrl = 'http://192.168.1.103:5000/api/v1';

  // ── Products ───────────────────────────────────────────────────────────
  static const String products = '/products';
  static String product(String id) => '/products/$id';

  // ── Categories ─────────────────────────────────────────────────────────
  static const String categories = '/categories';

  // ── Favorites ──────────────────────────────────────────────────────────
  static const String favorites = '/favorites';
  static String favorite(String productId) => '/favorites/$productId';

  // ── Auth checks (public, no token required) ────────────────────────────
  static const String checkPhone = '/auth/check-phone';

  // ── Profile ────────────────────────────────────────────────────────────
  static const String profile = '/profile';
  static const String profileFcmToken = '/profile/fcm-token';

  // ── Addresses ──────────────────────────────────────────────────────────
  static const String addresses = '/addresses';
  static String address(String id) => '/addresses/$id';
  static String addressDefault(String id) => '/addresses/$id/default';

  // ── Orders ─────────────────────────────────────────────────────────────
  static const String orders = '/orders';
  static String order(String id) => '/orders/$id';

  // ── Tracking ───────────────────────────────────────────────────────────
  static String orderTracking(String orderId) =>
      '/orders/$orderId/tracking';

  // ── Checkout ───────────────────────────────────────────────────────────
  static const String checkout = '/checkout';

  // ── Payments ───────────────────────────────────────────────────────────
  static const String paymentsInitialize = '/payments/initialize';
  static String paymentStatus(String ref) => '/payments/$ref/status';
}
