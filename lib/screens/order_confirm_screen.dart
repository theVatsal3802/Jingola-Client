import 'package:flutter/material.dart';

import './home_screen.dart';

class OrderConfirmScreen extends StatelessWidget {
  static const routeName = "/order-confirm";
  const OrderConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                "assets/images/bag.png",
                fit: BoxFit.cover,
                height: 200,
                width: 200,
              ),
              Text(
                "Order Placed",
                textScaleFactor: 1,
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    HomeScreen.routeName,
                    (route) => false,
                  );
                },
                child: const Text(
                  "Back to Home",
                  textScaleFactor: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
