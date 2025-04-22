// import 'package:minifood_admin/data/models/dished_model.dart';

// class CartModel {
//   int userId;
//   List<DishedModel> dishes;
//   String id;

//   CartModel({required this.userId, required this.dishes, required this.id});

//   factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
//     userId: json["userId"],
//     dishes: List<DishedModel>.from(
//       json["items"].map((x) => DishedModel.fromJson(x)),
//     ),
//     id: json["_id"],
//   );

//   Map<String, dynamic> toJson() => {
//     "userId": userId,
//     "items": List<dynamic>.from(dishes.map((x) => x.toJson())),
//     "_id": id,
//   };
// }
