import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _cart;

  Map<String, CartItem> get cart {
    return {..._cart};
  }

  void addItemToCart(String productId, double price, String name) {
    _cart.update(
        productId, (dynamic existingItem) => existingItem['quantity']++,
        ifAbsent: () => CartItem(
            id: DateTime.now().toString(),
            name: name,
            quantity: 1,
            price: price));
  }
}
