import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../functions/other_functions.dart';

class BasketItemTile extends StatefulWidget {
  final Map<String, dynamic> item;
  const BasketItemTile({
    super.key,
    required this.item,
  });

  @override
  State<BasketItemTile> createState() => _BasketItemTileState();
}

class _BasketItemTileState extends State<BasketItemTile> {
  int itemQuantity = 0;
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> setItemQuantity() async {
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    final String? val = doc["basket"]["basketItems"][widget.item["name"]];
    if (val != null) {
      setState(() {
        itemQuantity = int.parse(val);
      });
    }
    if (val == "0") {
      await OtherFunctions.removeCompletelyFromBasket(
        itemName: widget.item["name"],
        itemQuantity: itemQuantity,
        price: double.parse(
          widget.item["price"],
        ),
      ).then(
        (_) {
          setState(() {
            isZero = true;
          });
        },
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setItemQuantity();
  }

  bool isAdding = false;
  bool isRemoving = false;
  bool isZero = false;

  @override
  Widget build(BuildContext context) {
    return isZero
        ? Container()
        : Dismissible(
            key: const ValueKey("basketItem"),
            background: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.delete,
                  color: Colors.red[800],
                ),
              ],
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              await OtherFunctions.removeCompletelyFromBasket(
                itemName: widget.item["name"],
                itemQuantity: itemQuantity,
                price: double.parse(widget.item["price"]),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.only(
                  top: 5,
                  right: 10,
                  left: 5,
                  bottom: 5,
                ),
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  backgroundImage: widget.item["imageUrl"] == ""
                      ? null
                      : NetworkImage(widget.item["imageUrl"]),
                ),
                title: Text(
                  widget.item["name"],
                  textScaleFactor: 1,
                  style: Theme.of(context).textTheme.headline5,
                ),
                subtitle: Text(
                  "Price per item: ₹${widget.item["price"]}",
                  textScaleFactor: 1,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        if (itemQuantity > 0) {
                          setState(() {
                            isRemoving = true;
                            itemQuantity--;
                          });
                          await OtherFunctions.removeFromBasket(
                            itemName: widget.item["name"],
                            itemQuantity: itemQuantity,
                            price: double.parse(widget.item["price"]),
                          ).then(
                            (_) {
                              if (itemQuantity != 0) {
                                setState(() {
                                  isRemoving = false;
                                });
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Item removed from Basket.",
                                      textScaleFactor: 1,
                                    ),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              }
                            },
                          );
                        }
                      },
                      icon: Icon(
                        Icons.do_disturb_on,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      "$itemQuantity",
                      textScaleFactor: 1,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    IconButton(
                      onPressed: () async {
                        setState(() {
                          isAdding = true;
                          itemQuantity++;
                        });
                        ScaffoldMessenger.of(context).clearSnackBars();
                        await OtherFunctions.addToBasket(
                          itemName: widget.item["name"],
                          itemQuantity: itemQuantity,
                          price: double.parse(widget.item["price"]),
                        ).then(
                          (_) {
                            setState(() {
                              isAdding = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Item added to Basket.",
                                  textScaleFactor: 1,
                                ),
                                duration: Duration(seconds: 1),
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
            ),
          );
  }
}
