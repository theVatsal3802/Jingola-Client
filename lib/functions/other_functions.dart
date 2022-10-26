import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  static List<List> getItemFromMap(Map<String, dynamic> items) {
    List a = List.from(items.keys);
    List b = List.from(items.values);
    return [a, b];
  }

  static Future<void> saveUser({
    required String name,
    required String userId,
    required String phoneNumer,
    required BuildContext context,
  }) async {
    try {
      await FirebaseFirestore.instance.collection("users").doc(userId).set(
        {
          "name": name,
          "phoneNumber": phoneNumer,
          "basket": {"basketItems": {}, "subtotal": "0"},
          "pastOrders": [],
          "vouchersUsed": [],
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Something went wrong, please try again.",
            textScaleFactor: 1,
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  static Future<void> updateUser({
    required String name,
    required BuildContext context,
  }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .update(
        {
          "name": name,
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Something went wrong, please try again.",
            textScaleFactor: 1,
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
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
    final fee = await FirebaseFirestore.instance
        .collection("settings")
        .doc("App Settings")
        .get();
    double fees = double.parse(
      fee.get("delivery fees"),
    );
    double subtotal = double.parse(basket["basket"]["subtotal"]);
    return subtotal + fees;
  }

  static Future<List<dynamic>> getCheckOutDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    double total = await getTotal();
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    final appData = await FirebaseFirestore.instance
        .collection("settings")
        .doc("App Settings")
        .get();
    final deliveryFee = appData.get("delivery fees");
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
      deliveryFee,
      baskets,
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

  static Future<bool> placeOrder({
    required String location,
    required BuildContext context,
    required String total,
    required String userId,
    required Map<String, dynamic> items,
  }) async {
    try {
      await FirebaseFirestore.instance.collection("orders").add(
        {
          "date":
              "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
          "items": items,
          "location": location,
          "status": "Pending",
          "total": total,
          "userId": userId,
          "time": Timestamp.now(),
        },
      );
      await FirebaseFirestore.instance.collection("users").doc(userId).update(
        {
          "basket": {"basketItems": {}, "subtotal": "0"},
        },
      );
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Something went wrong, please try again",
            textScaleFactor: 1,
          ),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
  }
}
