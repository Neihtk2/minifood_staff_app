// ignore_for_file: public_member_api_docs, sort_constructors_first
class AuthModel {
  String mess;
  String token;
  String role;
  int userId;
  AuthModel({required this.mess, required this.token, required this.role, required this.userId});
  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      mess: json['message'],
      userId: json['userId'],
      token: json['token'],
      role: json['role'],
    );
  }
}
