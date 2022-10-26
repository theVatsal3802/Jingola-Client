import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jingola_client/screens/checkout_screen.dart';

import '../functions/other_functions.dart';
import '../widgets/basket_item_tile.dart';
import '../widgets/custom_drawer.dart';

class BasketScreen extends StatelessWidget {
  static const routeName = "/basket";
  BasketScreen({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: Text(
          "Basket",
          textScaleFactor: 1,
          style: Theme.of(context).textTheme.headline4!.copyWith(
                color: Colors.white,
              ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.arrow_back),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "Basket Items",
                textScaleFactor: 1,
                style: Theme.of(context).textTheme.headline3!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(user!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  return FutureBuilder(
                    future: OtherFunctions.getItemsfromItemName(user!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                      return snapshot.data!.isEmpty
                          ? Center(
                              child: Text(
                                "No Items in basket",
                                textScaleFactor: 1,
                                style: Theme.of(context).textTheme.headline4,
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return BasketItemTile(
                                    item: snapshot.data![index]);
                              },
                              itemCount: snapshot.data!.length,
                            );
                    },
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Total",
                textScaleFactor: 1,
                style: Theme.of(context).textTheme.headline3!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(user!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: 200,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                    );
                  }
                  return Container(
                    height: 200,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Subtotal",
                                  textScaleFactor: 1,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                FutureBuilder(
                                  future: OtherFunctions.getSubtotal(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator
                                          .adaptive();
                                    }
                                    return Text(
                                      "₹${snapshot.data!.toStringAsFixed(2)}",
                                      textScaleFactor: 1,
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Delivery fee",
                                  textScaleFactor: 1,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("settings")
                                      .doc("App Settings")
                                      .snapshots(),
                                  builder: (context, feeSnapshot) {
                                    if (feeSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container();
                                    }
                                    return Text(
                                      "₹${feeSnapshot.data!.data()!["delivery fees"]}",
                                      textScaleFactor: 1,
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total",
                                  textScaleFactor: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                                FutureBuilder(
                                  future: OtherFunctions.getTotal(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator
                                          .adaptive();
                                    }
                                    return Text(
                                      "₹${snapshot.data!.toStringAsFixed(2)}",
                                      textScaleFactor: 1,
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 30,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("settings")
                    .doc("App Settings")
                    .snapshots(),
                builder: (context, feeSnapshot) {
                  if (feeSnapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator.adaptive();
                  }
                  return ElevatedButton(
                    onPressed: () async {
                      await OtherFunctions.getTotal().then(
                        (value) {
                          if (value >=
                              double.parse(feeSnapshot.data!
                                  .data()!["minimum amount"])) {
                            Navigator.of(context)
                                .pushNamed(CheckoutScreen.routeName);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Minimum total amount must be ₹${feeSnapshot.data!.data()!["minimum amount"]}",
                                  textScaleFactor: 1,
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                    ),
                    child: const Text(
                      "Go to Checkout",
                      textScaleFactor: 1,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
