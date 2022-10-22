import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Orders",
        ),
      ),
    );
  }
}
