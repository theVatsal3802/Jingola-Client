import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../functions/other_functions.dart';
import './order_confirm_screen.dart';
import './voucher_screen.dart';
import './home_screen.dart';

class CheckoutScreen extends StatefulWidget {
  static const routeName = "/checkout";
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late Future<List<dynamic>> myData;
  final locationController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool isAddressSet = false;
  bool isConfirm = false;
  User? user = FirebaseAuth.instance.currentUser;
  bool loading = false;
  bool isPlaced = false;
  bool isApplying = false;
  bool goBack = true;

  late Future<bool> checkVouchers;
  String? voucher;

  Future<bool> vouchers() async {
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    final result = doc.get("voucherApplied");
    final thisVoucher = doc.get("inThisOrder");
    if (result) {
      goBack = false;
    } else {
      goBack = true;
    }
    voucher = thisVoucher;
    final v = await FirebaseFirestore.instance
        .collection("vouchers")
        .doc(voucher)
        .get();
    final vouchers = v.data();
    myData = OtherFunctions.getCheckOutDetails(result, vouchers!, false);
    return result;
  }

  @override
  void initState() {
    super.initState();
    myData = OtherFunctions.getCheckOutDetails(false, {}, false);
    if (user != null) {
      checkVouchers = vouchers();
    }
  }

  @override
  void dispose() {
    super.dispose();
    locationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "Checkout",
          textScaleFactor: 1,
          style: Theme.of(context).textTheme.headline5!.copyWith(
                color: Colors.white,
              ),
        ),
      ),
      body: FutureBuilder(
        future: checkVouchers,
        builder: (context, vouchersnapshot) {
          if (vouchersnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: FutureBuilder(
                future: myData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order Items",
                        textScaleFactor: 1,
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    snapshot.data![1][index],
                                    textScaleFactor: 1,
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                  Text(
                                    snapshot.data![2][index],
                                    textScaleFactor: 1,
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: snapshot.data![4],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Subtotal:",
                              textScaleFactor: 1,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            Text(
                              "₹${snapshot.data![3]}",
                              textScaleFactor: 1,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Delivery Fee:",
                              textScaleFactor: 1,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            Text(
                              "₹${snapshot.data![5]}",
                              textScaleFactor: 1,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total:",
                              textScaleFactor: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                            Text(
                              "₹${snapshot.data![0]}",
                              textScaleFactor: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      if (vouchersnapshot.data ?? false)
                        Center(
                          child: Text(
                            "Total price decreased by voucher value",
                            textScaleFactor: 1,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Delivery Address",
                              textScaleFactor: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (!isConfirm)
                              Form(
                                key: _formKey,
                                child: TextFormField(
                                  controller: locationController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    prefixIcon: const Icon(Icons.location_on),
                                  ),
                                  autocorrect: true,
                                  enableSuggestions: true,
                                  textCapitalization: TextCapitalization.words,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 4,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter delivery address.";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            if (isConfirm)
                              Text(
                                locationController.text,
                                textScaleFactor: 1,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (loading)
                              const CircularProgressIndicator.adaptive(),
                            if (!isAddressSet && !loading)
                              ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  await OtherFunctions.determinePosition().then(
                                    (value) {
                                      setState(() {
                                        loading = false;
                                        locationController.text = value;
                                        isAddressSet = true;
                                      });
                                    },
                                  );
                                },
                                child: const Text(
                                  "Determine Address",
                                  textScaleFactor: 1,
                                ),
                              ),
                            if (isAddressSet && !isConfirm && !loading)
                              ElevatedButton(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  bool valid =
                                      _formKey.currentState!.validate();
                                  if (!valid) {
                                    return;
                                  }
                                  _formKey.currentState!.save();
                                  setState(() {
                                    isConfirm = true;
                                  });
                                },
                                child: const Text(
                                  "Confirm Address",
                                  textScaleFactor: 1,
                                ),
                              ),
                            if (isAddressSet &&
                                isConfirm &&
                                !loading &&
                                !isPlaced)
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isConfirm = false;
                                  });
                                },
                                child: const Text(
                                  "Edit Address",
                                  textScaleFactor: 1,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 125,
                        width: double.infinity,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            isApplying
                                ? const CircularProgressIndicator.adaptive()
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        vouchersnapshot.data ?? false
                                            ? "Voucher Applied"
                                            : "Do you have any voucher?",
                                        textScaleFactor: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                        textAlign: TextAlign.center,
                                        softWrap: true,
                                      ),
                                      StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection("settings")
                                            .doc("App Settings")
                                            .snapshots(),
                                        builder: (context, feeSnapshot) {
                                          if (feeSnapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator
                                                .adaptive();
                                          }
                                          return TextButton(
                                            onPressed:
                                                vouchersnapshot.data ?? false
                                                    ? () async {
                                                        setState(() {
                                                          isApplying = true;
                                                        });
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "vouchers")
                                                            .doc(voucher)
                                                            .get()
                                                            .then(
                                                          (value) async {
                                                            await OtherFunctions
                                                                .removeVoucher(
                                                              value.data()!,
                                                            );
                                                          },
                                                        ).then(
                                                          (value) {
                                                            checkVouchers =
                                                                vouchers().then(
                                                              (value) async {
                                                                if (!value) {
                                                                  final voucherValue = await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "vouchers")
                                                                      .doc(
                                                                          voucher)
                                                                      .get();
                                                                  final myVoucher =
                                                                      voucherValue
                                                                          .data();
                                                                  setState(() {
                                                                    isApplying =
                                                                        false;
                                                                    myData =
                                                                        OtherFunctions
                                                                            .getCheckOutDetails(
                                                                      true,
                                                                      myVoucher!,
                                                                      true,
                                                                    );
                                                                    checkVouchers =
                                                                        vouchers();
                                                                  });
                                                                  await OtherFunctions
                                                                      .removeId();
                                                                  return true;
                                                                }
                                                                return false;
                                                              },
                                                            );
                                                          },
                                                        );
                                                      }
                                                    : () async {
                                                        await OtherFunctions
                                                                .getTotal()
                                                            .then(
                                                          (value) {
                                                            if (value >=
                                                                double.parse(feeSnapshot
                                                                        .data!
                                                                        .data()![
                                                                    "minimum amount"])) {
                                                              Navigator.of(
                                                                      context)
                                                                  .pushNamed(
                                                                VoucherScreen
                                                                    .routeName,
                                                                arguments: true,
                                                              )
                                                                  .then(
                                                                (_) {
                                                                  checkVouchers =
                                                                      vouchers()
                                                                          .then(
                                                                    (value) async {
                                                                      if (value) {
                                                                        final voucherValue = await FirebaseFirestore
                                                                            .instance
                                                                            .collection("vouchers")
                                                                            .doc(voucher)
                                                                            .get();
                                                                        final vouchers =
                                                                            voucherValue.data();
                                                                        setState(
                                                                            () {
                                                                          isApplying =
                                                                              false;
                                                                          myData =
                                                                              OtherFunctions.getCheckOutDetails(
                                                                            true,
                                                                            vouchers!,
                                                                            false,
                                                                          );
                                                                        });
                                                                        return true;
                                                                      }
                                                                      return false;
                                                                    },
                                                                  );
                                                                },
                                                              );
                                                            } else {
                                                              setState(() {
                                                                isApplying =
                                                                    false;
                                                              });
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                    "Minimum total amount must be ₹${feeSnapshot.data!.data()!["minimum amount"]} to be able to apply voucher",
                                                                    textScaleFactor:
                                                                        1,
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                          },
                                                        );
                                                      },
                                            style: TextButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 30,
                                              ),
                                            ),
                                            child: Text(
                                              vouchersnapshot.data ?? false
                                                  ? "Remove Voucher"
                                                  : "Apply Voucher",
                                              textScaleFactor: 1,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                            Image.asset(
                              "assets/images/coupon.png",
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (isPlaced)
                        const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      if (!isPlaced)
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              if (!isConfirm) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Please confirm your delivery address",
                                      textScaleFactor: 1,
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                return;
                              }
                              setState(() {
                                isPlaced = true;
                              });
                              await OtherFunctions.placeOrder(
                                location: locationController.text.trim(),
                                context: context,
                                total: snapshot.data![0],
                                userId: FirebaseAuth.instance.currentUser!.uid,
                                items: snapshot.data![6],
                              ).then(
                                (value) {
                                  setState(() {
                                    isPlaced = false;
                                  });
                                  if (value) {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                      OrderConfirmScreen.routeName,
                                      (route) => false,
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
                              "Place Order",
                              textScaleFactor: 1,
                            ),
                          ),
                        ),
                      if (goBack)
                        Center(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                HomeScreen.routeName,
                                (route) => false,
                              );
                            },
                            child: const Text(
                              "CANCEL PLACING OF ORDER",
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
