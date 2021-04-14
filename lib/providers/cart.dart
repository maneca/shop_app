import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _cart = {};

  Map<String, CartItem> get cart {
    return {..._cart};
  }

  int get itemCount {
    return _cart.length;
  }

  double get totalAmount {
    var _total = 0.0;

    _cart.forEach((key, value) {
      _total += value.price * value.quantity;
    });

    return _total;
  }

  void addItemToCart(String productId, double price, String name) {

    if(_cart.containsKey(productId)){
      _cart[productId].quantity++;
    }
    else{
      _cart.putIfAbsent(productId, () => CartItem(
          id: DateTime.now().toString(),
          name: name,
          quantity: 1,
          price: price));
    }
    notifyListeners();
  }

  void removeSingleItem(String productId){
    if(!_cart.containsKey(productId)){
      return;
    }

    if(_cart[productId].quantity > 1){
      _cart.update(productId, (value) => new CartItem(id: value.id, name: value.name, quantity: value.quantity - 1, price: value.price));
    }else{
      _cart.remove(productId);
    }
    notifyListeners();
  }

  void removeItem(String productId){
    _cart.remove(productId);
    notifyListeners();
  }

  void clearCart(){
    _cart = {};
    notifyListeners();
  }
}
