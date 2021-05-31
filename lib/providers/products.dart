import 'package:flutter/material.dart';

import 'product.dart';
import '../data/dummy_data.dart';

class Products with ChangeNotifier {
  List<Product> _items =  DUMMY_PRODUCTS;

  List<Product> get items {
    // this returns a copy of the list
    // we need to return a copy because we need to call a specific 
    // method to alert all the listeners that the list has changed
    return [..._items];
  }

  List<Product> get favourites {
    return _items.where((elem) => elem.isFavourite).toList();
  }

  Product findProductById(String id){
    return _items.firstWhere((element) => element.id == id);
  }
  
  void addProduct(Product product){
    _items.add(product);
    notifyListeners();
  }
}