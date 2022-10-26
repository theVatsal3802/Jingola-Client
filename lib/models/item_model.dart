import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final String description;
  final bool isVeg;
  final bool instock;

  const Item({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.isVeg,
    required this.instock,
    this.imageUrl = "",
  });

  factory Item.fromSnapshot(DocumentSnapshot snapshot) {
    return Item(
      id: snapshot.id,
      name: snapshot["name"],
      category: snapshot["category"],
      price: double.parse(snapshot["price"]),
      imageUrl: snapshot["imageUrl"],
      description: snapshot["description"],
      isVeg: snapshot["isVeg"],
      instock: snapshot["in stock"],
    );
  }
}
