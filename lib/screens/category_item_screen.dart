import 'package:flutter/material.dart';

import '../models/category_model.dart';
import '../functions/other_functions.dart';
import '../widgets/item_box.dart';
import './basket_screen.dart';

class CategoryItemScreen extends StatefulWidget {
  static const routeName = "/category-items";
  const CategoryItemScreen({super.key});

  @override
  State<CategoryItemScreen> createState() => _CategoryItemScreenState();
}

class _CategoryItemScreenState extends State<CategoryItemScreen> {
  bool visible = false;

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
                Navigator.of(context)
                    .pushNamed(
                  BasketScreen.routeName,
                  arguments: true,
                )
                    .then((value) {
                  setState(() {
                    visible = true;
                  });
                });
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (visible)
              Container(
                margin: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      visible = false;
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Some data Might have changed\nRefresh Page",
                      textScaleFactor: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            StreamBuilder(
              stream: OtherFunctions.getItems(category.name),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                return snapshot.data.length == 0
                    ? Center(
                        child: Text(
                          "No Menu Items available yet!",
                          textScaleFactor: 1,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ItemBox(
                            item: snapshot.data[index],
                          );
                        },
                        itemCount: snapshot.data.length,
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
