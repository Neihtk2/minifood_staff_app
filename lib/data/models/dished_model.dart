import 'package:intl/intl.dart';

class DishedModel {
  final String id;
  final String name;
  final int price;
  final String image;
  final String description;
  final double averageRating;
  List<RatingModel> ratings;
  final int ratingCount;
  final String category;
  int quantity;

  DishedModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.averageRating,
    List<RatingModel>? ratings,
    required this.ratingCount,
    required this.category,

    this.quantity = 0,
  }) : ratings = ratings ?? [];

  factory DishedModel.fromJson(Map<String, dynamic> json) => DishedModel(
    id: json["_id"] ?? "",
    name: json["name"],
    price: json["price"],
    image: json["image"],
    description: json["description"] ?? "",
    category: json["category"] ?? "null",
    quantity: json["quantity"] ?? 0,
    averageRating: (json["averageRating"] ?? 0).toDouble(),
    ratings:
        (json["ratings"] as List?)
            ?.map((e) => RatingModel.fromJson(e))
            .toList() ??
        [],
    ratingCount: json["ratingCount"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "price": price,
    "image": image,
    "category": category,
    "quantity": quantity,
  };
}

class RatingModel {
  final String id;
  final int star;
  final String comment;
  final DateTime date;

  RatingModel({
    required this.id,
    required this.star,
    required this.comment,
    required this.date,
  });

  String get formattedDate => DateFormat('dd-MM-yyyy').format(date);

  factory RatingModel.fromJson(Map<String, dynamic> json) => RatingModel(
    id: json["_id"] ?? "",
    star: json["star"] ?? 0,
    comment: json["comment"]?.toString() ?? "",
    date: DateTime.tryParse(json["date"] ?? "") ?? DateTime.now(),
  );
}
