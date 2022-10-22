import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  static const routeName = "/checkout";
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Checkout",
        ),
      ),
    );
  }
}
