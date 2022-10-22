import 'package:flutter/material.dart';

import '../models/category_model.dart';
import '../screens/category_item_screen.dart';

class CategoryBox extends StatelessWidget {
  final Category category;
  const CategoryBox({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          CategoryItemScreen.routeName,
          arguments: category,
        );
      },
      child: Card(
        borderOnForeground: false,
        elevation: 3,
        child: Container(
          width: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Stack(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Image.network(
                      category.imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              FittedBox(
                child: Text(
                  category.name,
                  textScaleFactor: 1,
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Colors.black54,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
