import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/item_model.dart';
import './basket_screen.dart';
import '../functions/other_functions.dart';

class ItemDescriptionScreen extends StatefulWidget {
  final Item item;
  static const routeName = "/item-description";
  const ItemDescriptionScreen({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  State<ItemDescriptionScreen> createState() => _ItemDescriptionScreenState();
}

class _ItemDescriptionScreenState extends State<ItemDescriptionScreen> {
  bool isAdding = false;
  bool isRemoving = false;
  int itemQuantity = 0;
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> setItemQuantity() async {
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    final String? val = doc["basket"]["basketItems"][widget.item.name];
    if (val != null) {
      setState(() {
        itemQuantity = int.parse(val);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setItemQuantity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      extendBody: false,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  BasketScreen.routeName,
                  arguments: true,
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
              ),
              child: const Text(
                "Basket",
                textScaleFactor: 1,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop(itemQuantity);
        },
        tooltip: "Back to all items",
        child: const Icon(
          Icons.arrow_back,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(
                    MediaQuery.of(context).size.width,
                    100,
                  ),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                    widget.item.imageUrl,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.item.name,
              textScaleFactor: 1,
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                widget.item.description,
                textScaleFactor: 1,
                style: Theme.of(context).textTheme.headline3!.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 30,
                right: 30,
                bottom: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Price",
                    textScaleFactor: 1,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    "₹ ${widget.item.price.toStringAsFixed(2)}",
                    textScaleFactor: 1,
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 30,
                right: 30,
                bottom: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Availablility",
                    textScaleFactor: 1,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    widget.item.instock ? "Available" : "Not Available",
                    textScaleFactor: 1,
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color:
                              widget.item.instock ? Colors.green : Colors.red,
                        ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 30,
                right: 30,
                bottom: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Type:",
                    textScaleFactor: 1,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    widget.item.isVeg ? "Veg" : "Non Veg",
                    textScaleFactor: 1,
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: widget.item.isVeg ? Colors.green : Colors.red,
                        ),
                  ),
                ],
              ),
            ),
            if (isAdding || isRemoving)
              const CircularProgressIndicator.adaptive(),
            if (!isAdding && !isRemoving)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "Quantity in Basket",
                        textScaleFactor: 1,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        if (itemQuantity > 0) {
                          setState(() {
                            isRemoving = true;
                            itemQuantity--;
                          });
                          await OtherFunctions.removeFromBasket(
                            itemName: widget.item.name,
                            itemQuantity: itemQuantity,
                            price: widget.item.price,
                          ).then(
                            (_) {
                              setState(() {
                                isRemoving = false;
                              });
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Item removed from basket",
                                    textScaleFactor: 1,
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                          );
                        } else {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Cannot remove items which are not in basket",
                                textScaleFactor: 1,
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      icon: Icon(
                        Icons.do_not_disturb_on,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      itemQuantity.toString(),
                      textScaleFactor: 1,
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                    IconButton(
                      onPressed: () async {
                        setState(() {
                          isAdding = true;
                          itemQuantity++;
                        });
                        await OtherFunctions.addToBasket(
                          itemName: widget.item.name,
                          itemQuantity: itemQuantity,
                          price: widget.item.price,
                        ).then(
                          (_) {
                            setState(() {
                              isAdding = false;
                            });
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Item added to basket",
                                  textScaleFactor: 1,
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.add_circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            if (!isAdding && !isRemoving)
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isRemoving = true;
                  });
                  await OtherFunctions.removeCompletelyFromBasket(
                    itemName: widget.item.name,
                    itemQuantity: itemQuantity,
                    price: widget.item.price,
                  ).then(
                    (_) {
                      setState(() {
                        isRemoving = false;
                        itemQuantity = 0;
                      });
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Item deleted from basket",
                            textScaleFactor: 1,
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                },
                child: const Text(
                  "Delete item from basket",
                  textScaleFactor: 1,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
