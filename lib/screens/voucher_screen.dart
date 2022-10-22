import 'package:flutter/material.dart';

class VoucherScreen extends StatelessWidget {
  static const routeName = "/vouchers";
  const VoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Vouchers",
        ),
      ),
    );
  }
}
