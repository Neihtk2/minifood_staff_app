class Endpoints {
  Endpoints._();
  static const String baseUrl = "http://10.0.2.2:5000";
  // static const String baseWeb = "http://localhost:5000";
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/signup';
  static const String cart = '/api/users/cart';
  static const String orders = '/api/orders';
  static const String topDishes = '/api/orders/top-dishes';
  static const String dishes = '/api/dishes';
  static const String vouchers = '/api/vouchers';
  static const String profile = '/api/users/profile';
  static const String changePassword = '/api/users/change-password';

  // User endpoints
  static const String getUserProfile = '/users/profile';
}
