import 'package:flutter/material.dart';

import '../models/category_model.dart';
import '../functions/other_functions.dart';
import '../widgets/item_box.dart';
import './basket_screen.dart';

class CategoryItemScreen extends StatelessWidget {
  static const routeName = "/category-items";
  const CategoryItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Category category =
        ModalRoute.of(context)!.settings.arguments as Category;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          category.name,
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
              onPressed: () {
                Navigator.of(context).pushNamed(BasketScreen.routeName);
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
      body: StreamBuilder(
        stream: OtherFunctions.getItems(category.name),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              return ItemBox(
                item: snapshot.data[index],
              );
            },
            itemCount: snapshot.data.length,
          );
        },
      ),
    );
  }
}
