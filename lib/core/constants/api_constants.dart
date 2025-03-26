class Endpoints {
  Endpoints._();
  static const String baseUrl = "http://10.0.2.2:5000";
  static const String baseWeb = "localhost:5000";
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/signup';
  static const String getAllUsers = '/api/admin/users';
  static const String dishes = '/api/dishes';
  static const String postCoupons = '/api/admin/coupons';
  static const String topDishes = '/api/orders/top-dishes';
  static const String unlock = '/api/orders/unlock/idUser';
  static const String getAllDishes = '/api/dishes';

  // User endpoints
  static const String getUserProfile = '/users/profile';
  static const String updateAvatar = '/users/avatar';
}
