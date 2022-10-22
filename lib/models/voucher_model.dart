import 'package:cloud_firestore/cloud_firestore.dart';

class Voucher {
  final String id;
  final String code;
  final String value;
  final String description;
  final String imageUrl;
  final String type;

  const Voucher({
    required this.id,
    required this.code,
    required this.value,
    required this.description,
    required this.imageUrl,
    required this.type,
  });

  factory Voucher.fromSnapshot(DocumentSnapshot snapshot) {
    return Voucher(
      id: snapshot.id,
      code: snapshot["code"],
      description: snapshot["description"],
      value: snapshot["value"],
      imageUrl: snapshot["imageUrl"],
      type: snapshot["type"],
    );
  }
}
