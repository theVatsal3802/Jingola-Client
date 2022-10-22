class Basket {
  final Map<String, dynamic> basketItems;
  final double subtotal;

  const Basket({
    this.basketItems = const {},
    required this.subtotal,
  });
}
