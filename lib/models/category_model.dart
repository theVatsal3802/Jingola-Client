import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String name;
  final String imageUrl;

  const Category({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Category.fromSnapshot(DocumentSnapshot snapshot) {
    return Category(
      id: snapshot.id,
      name: snapshot['name'],
      imageUrl: snapshot['imageUrl'],
    );
  }
}
