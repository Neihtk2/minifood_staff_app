class DishedModel {
  final String id;
  final String name;
  final int price;
  final String image;
  final String category;
  int quantity;

  DishedModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.category,
    this.quantity = 0,
  });

  factory DishedModel.fromJson(Map<String, dynamic> json) => DishedModel(
    id: json["_id"],
    name: json["name"],
    price: json["price"],
    image: json["image"],
    category: json["category"] ?? "null",
    quantity: json["quantity"] ?? 0,
  );
}
