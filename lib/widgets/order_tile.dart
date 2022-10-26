import 'package:flutter/material.dart';

import '../functions/other_functions.dart';

class OrderTile extends StatelessWidget {
  final Map<String, dynamic> order;
  const OrderTile({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_month),
                Text(
                  order["date"],
                  textScaleFactor: 1,
                  style: Theme.of(context).textTheme.headline5,
                ),
                const Spacer(),
                Text(
                  order["status"],
                  textScaleFactor: 1,
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: order["status"] == "Pending"
                            ? Theme.of(context).colorScheme.primary
                            : order["status"] == "Delivered"
                                ? Colors.green
                                : Colors.black,
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              "Total amount: ₹${order["total"]}",
              textScaleFactor: 1,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              "Items",
              textScaleFactor: 1,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                List<List> items =
                    OtherFunctions.getItemFromMap(order["items"]);
                List itemName = items[0];
                List itemQuantity = items[1];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      itemName[index],
                      textScaleFactor: 1,
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                    Text(
                      itemQuantity[index],
                      textScaleFactor: 1,
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ],
                );
              },
              itemCount: order["items"].length,
            ),
          ),
        ],
      ),
    );
  }
}
