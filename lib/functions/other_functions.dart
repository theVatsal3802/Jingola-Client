import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/category_model.dart';
import '../models/item_model.dart';
import '../models/voucher_model.dart';

class OtherFunctions {
  static Stream<List<Category>> getCategories() {
    return FirebaseFirestore.instance.collection("categories").snapshots().map(
      (snapshot) {
        return snapshot.docs
            .map(
              (docs) => Category.fromSnapshot(docs),
            )
            .toList();
      },
    );
  }

  static Stream<List<Item>> getItems(String category) {
    return FirebaseFirestore.instance
        .collection("menu")
        .where(
          "category",
          isEqualTo: category,
        )
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs
            .map(
              (docs) => Item.fromSnapshot(docs),
            )
            .toList();
      },
    );
  }

  static Stream<List<Voucher>> getVouchers() {
    return FirebaseFirestore.instance.collection("vouchers").snapshots().map(
      (snapshot) {
        return snapshot.docs
            .map(
              (docs) => Voucher.fromSnapshot(docs),
            )
            .toList();
      },
    );
  }

  static Future<void> saveUser({
    required String name,
    required String userId,
    required String phoneNumer,
  }) async {
    await FirebaseFirestore.instance.collection("users").doc(userId).set(
      {
        "name": name,
        "phoneNumber": phoneNumer,
        "basket": {"basketItems": {}, "subtotal": "0"},
        "pastOrders": [],
        "vouchersUsed": [],
      },
    );
  }

  static Future<void> addToBasket({
    required String itemName,
    required int itemQuantity,
    required double price,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    final basket = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    var baskets = basket.data();
    double subtotal = double.parse(basket["basket"]["subtotal"]);
    subtotal = subtotal + price;
    Map<String, dynamic> basketItems = baskets!["basket"]["basketItems"];
    final addItem = {
      itemName: itemQuantity.toString(),
    };
    basketItems.addAll(addItem);
    await FirebaseFirestore.instance.collection("users").doc(user.uid).update(
      {
        "basket": {
          "basketItems": basketItems,
          "subtotal": subtotal.toStringAsFixed(2),
        },
      },
    );
  }

  static Future<void> removeFromBasket({
    required String itemName,
    required int itemQuantity,
    required double price,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    final basket = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    var baskets = basket.data();
    double subtotal = double.parse(basket["basket"]["subtotal"]);
    subtotal = subtotal - price;
    Map<String, dynamic> basketItems = baskets!["basket"]["basketItems"];
    final addItem = {
      itemName: itemQuantity.toString(),
    };
    basketItems.addAll(addItem);
    await FirebaseFirestore.instance.collection("users").doc(user.uid).update(
      {
        "basket": {
          "basketItems": basketItems,
          "subtotal": subtotal.toStringAsFixed(2),
        },
      },
    );
  }

  static Future<void> removeCompletelyFromBasket({
    required String itemName,
    required int itemQuantity,
    required double price,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    final basket = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    var baskets = basket.data();
    double subtotal = double.parse(basket["basket"]["subtotal"]);
    subtotal = subtotal - (price * itemQuantity);
    Map<String, dynamic> basketItems = baskets!["basket"]["basketItems"];
    basketItems.remove(itemName);
    await FirebaseFirestore.instance.collection("users").doc(user.uid).update(
      {
        "basket": {
          "basketItems": basketItems,
          "subtotal": subtotal.toStringAsFixed(2),
        },
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getItemsfromItemName(
      String userId) async {
    final doc =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
    final basket = doc.data();
    final Map<String, dynamic> basketItems = basket!["basket"]["basketItems"];
    List<Map<String, dynamic>> items = [];
    List<String> keys = basketItems.keys.toList();
    for (var name in keys) {
      final item = await FirebaseFirestore.instance
          .collection("menu")
          .where(
            "name",
            isEqualTo: name,
          )
          .get();
      items.add(item.docs.first.data());
    }
    return items;
  }
}
