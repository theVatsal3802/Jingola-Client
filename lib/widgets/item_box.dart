import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../functions/other_functions.dart';
import '../screens/item_description_screen.dart';
import '../models/item_model.dart';

class ItemBox extends StatefulWidget {
  final Item item;
  const ItemBox({
    super.key,
    required this.item,
  });

  @override
  State<ItemBox> createState() => _ItemBoxState();
}

class _ItemBoxState extends State<ItemBox> {
  int itemQuantity = 0;
  bool isAdding = false;
  bool isRemoving = false;
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
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ItemDescriptionScreen(
                item: widget.item,
              );
            },
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.only(
                top: 5,
                right: 10,
                left: 5,
                bottom: 5,
              ),
              leading: CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                backgroundImage: widget.item.imageUrl == ""
                    ? null
                    : NetworkImage(widget.item.imageUrl),
              ),
              title: Text(
                widget.item.name,
                textScaleFactor: 1,
                style: Theme.of(context).textTheme.headline5,
              ),
              subtitle: Text(
                "₹${widget.item.price.toStringAsFixed(2)}",
                textScaleFactor: 1,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              trailing: isAdding
                  ? const CircularProgressIndicator.adaptive()
                  : isRemoving
                      ? const CircularProgressIndicator.adaptive()
                      : widget.item.instock
                          ? Row(
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
                                        itemName: widget.item.name,
                                        itemQuantity: itemQuantity,
                                        price: widget.item.price,
                                      ).then(
                                        (_) {
                                          setState(() {
                                            isRemoving = false;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .clearSnackBars();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Item removed from Basket.",
                                                textScaleFactor: 1,
                                              ),
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .clearSnackBars();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Please Add some items before removing.",
                                            textScaleFactor: 1,
                                          ),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    Icons.do_disturb_on,
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
                                    ScaffoldMessenger.of(context)
                                        .clearSnackBars();
                                    await OtherFunctions.addToBasket(
                                      itemName: widget.item.name,
                                      itemQuantity: itemQuantity,
                                      price: widget.item.price,
                                    ).then(
                                      (_) {
                                        setState(() {
                                          isAdding = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                if (widget.item.isVeg)
                                  Image.asset(
                                    "assets/images/veg.png",
                                    height: 20,
                                    width: 20,
                                    fit: BoxFit.contain,
                                  ),
                                if (!widget.item.isVeg)
                                  Image.asset(
                                    "assets/images/nonVeg.png",
                                    height: 20,
                                    width: 20,
                                    fit: BoxFit.contain,
                                  ),
                              ],
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Out of Stock",
                                  textScaleFactor: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                        color: Colors.red,
                                      ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                if (widget.item.isVeg)
                                  Image.asset(
                                    "assets/images/veg.png",
                                    height: 20,
                                    width: 20,
                                    fit: BoxFit.contain,
                                  ),
                                if (!widget.item.isVeg)
                                  Image.asset(
                                    "assets/images/nonVeg.png",
                                    height: 20,
                                    width: 20,
                                    fit: BoxFit.contain,
                                  ),
                              ],
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
