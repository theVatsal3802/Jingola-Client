import './item_model.dart';

class Basket {
  final List<Item> items;

  const Basket({this.items = const <Item>[]});

  Map itemQuantity(List items) {
    var quantity = {};
    for (var item in items) {
      if (!quantity.containsKey(item)) {
        quantity[item] = 1;
      } else {
        quantity[item]++;
      }
    }
    return quantity;
  }

  double get subTotal =>
      items.fold(0, (total, current) => total + current.price);

  double total(double subTotal) {
    return subTotal + 10;
  }

  String get subTotalString => subTotal.toStringAsFixed(2);

  String get totalString => total(subTotal).toStringAsFixed(2);
}
