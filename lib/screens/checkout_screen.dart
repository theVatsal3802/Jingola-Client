import 'package:flutter/material.dart';

import '../functions/other_functions.dart';
import './order_confirm_screen.dart';

class CheckoutScreen extends StatefulWidget {
  static const routeName = "/checkout";
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late Future<List<dynamic>> data;
  final locationController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool isAddressSet = false;
  bool isConfirm = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    data = OtherFunctions.getCheckOutDetails();
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
      extendBody: false,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
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
                Navigator.of(context).pushNamed(OrderConfirmScreen.routeName);
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
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder(
            future: OtherFunctions.getCheckOutDetails(),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                snapshot.data![1][index],
                                textScaleFactor: 1,
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              Text(
                                snapshot.data![2][index],
                                textScaleFactor: 1,
                                style: Theme.of(context).textTheme.headline5,
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
                          "${snapshot.data![5]}",
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
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        Text(
                          "₹${snapshot.data![0]}",
                          textScaleFactor: 1,
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
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
                                  color: Theme.of(context).colorScheme.primary),
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
                        if (loading) const CircularProgressIndicator.adaptive(),
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
                              bool valid = _formKey.currentState!.validate();
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
                        if (isAddressSet && isConfirm && !loading)
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
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
