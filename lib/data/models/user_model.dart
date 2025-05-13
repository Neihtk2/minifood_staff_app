class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final String? role;
  final String? phone;
  final String? address;
  final String? image;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.role,
    this.phone,
    this.address,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
    };
  }
}
