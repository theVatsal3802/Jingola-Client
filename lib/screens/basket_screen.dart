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
    final bool button = ModalRoute.of(context)!.settings.arguments as bool;
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
      floatingActionButtonLocation:
          button ? FloatingActionButtonLocation.startFloat : null,
      floatingActionButton: button
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.arrow_back),
            )
          : null,
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
                    builder: (context, itemsnapshot) {
                      if (itemsnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                      return itemsnapshot.data == null
                          ? Container()
                          : itemsnapshot.data!.isEmpty
                              ? Center(
                                  child: Text(
                                    "No Items in basket",
                                    textScaleFactor: 1,
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return BasketItemTile(
                                        item: itemsnapshot.data![index]);
                                  },
                                  itemCount: itemsnapshot.data!.length,
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
                height: 20,
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
                        (value) async {
                          if (value >=
                              double.parse(feeSnapshot.data!
                                  .data()!["minimum amount"])) {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    "Are you sure to proceed?",
                                    textScaleFactor: 1,
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                  content: Text(
                                    "You won't be able to come back to edit the cart once you proceed",
                                    textScaleFactor: 1,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: const Text(
                                        "NO",
                                        textScaleFactor: 1,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: const Text(
                                        "YES",
                                        textScaleFactor: 1,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ).then(
                              (value) {
                                if (value) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    CheckoutScreen.routeName,
                                    (route) => false,
                                  );
                                } else {
                                  return;
                                }
                              },
                            );
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
