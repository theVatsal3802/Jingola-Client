import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  static Future<List> getOrders() async {
    final pastOrders = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    pastOrders.get("pastOrders");
    final List orders = pastOrders.get("pastOrders");
    return orders;
  }

  static List<List> getItemFromMap(Map<String, dynamic> items) {
    List a = List.from(items.keys);
    List b = List.from(items.values);
    return [a, b];
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

  static Future<void> updateUser({
    required String name,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection("users").doc(user!.uid).update(
      {
        "name": name,
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

  static Future<double> getSubtotal() async {
    User? user = FirebaseAuth.instance.currentUser;
    final basket = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    double subtotal = double.parse(basket["basket"]["subtotal"]);
    return subtotal;
  }

  static Future<double> getTotal() async {
    User? user = FirebaseAuth.instance.currentUser;
    final basket = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    double subtotal = double.parse(basket["basket"]["subtotal"]);
    return subtotal + 20;
  }

  static Future<List<dynamic>> getCheckOutDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    double total = await getTotal();
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    final userData = doc.data();
    final Map<String, dynamic> basket = userData!["basket"];
    final items = basket.values;
    final baskets = items.first as Map<String, dynamic>;
    final basketItems = List.from(baskets.keys);
    final itemQuantity = List.from(baskets.values);
    return [
      total.toStringAsFixed(2),
      basketItems,
      itemQuantity,
      basket["subtotal"],
      basketItems.length,
      "₹20.00",
    ];
  }

  static Future<String> determinePosition() async {
    String address = "";
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(
        msg: "Please turn on Location Service",
        toastLength: Toast.LENGTH_LONG,
      );
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(
          msg: "Unable to determine address",
          toastLength: Toast.LENGTH_LONG,
        );
      }
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      address =
          "${place.name}, ${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country} - ${place.postalCode}";
    } catch (_) {
      Fluttertoast.showToast(
        msg: "Unable to determine address",
        toastLength: Toast.LENGTH_LONG,
      );
    }
    return address;
  }

  static Future<void> placeOrder() async {
    // TODO: Add this functions to write to firbase
    // TODO: Add voucher feature
  }
}
