import 'package:flutter/material.dart';

class BasketScreen extends StatelessWidget {
  static const routeName = "/basket";
  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Basket",
          textScaleFactor: 1,
          style: Theme.of(context).textTheme.headline4!.copyWith(
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
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
              ),
              child: const Text(
                "Go to Checkout",
                textScaleFactor: 1,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              // ListView.builder(
              //   shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              //   itemBuilder: (context, index) {
              //     List<Item> items = const Basket().basketItems;
              //     print(items);
              //     return ItemBox(item: items[index]);
              //   },
              //   itemCount: const Basket().basketItems.length,
              // )
            ],
          ),
        ),
      ),
    );
  }
}
