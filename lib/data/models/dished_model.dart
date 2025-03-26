class DishedModel {
  final String id;
  final String name;
  final int price;
  final String image;
  final String category;

  DishedModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.category,
  });

  factory DishedModel.fromJson(Map<String, dynamic> json) => DishedModel(
    id: json["_id"],
    name: json["name"],
    price: json["price"],
    image: json["image"],
    category: json["category"],
  );
}
