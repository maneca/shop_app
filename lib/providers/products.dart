import 'package:flutter/material.dart';
import 'package:shop_app/api/api.dart';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = []; //DUMMY_PRODUCTS;

  List<Product> get items {
    // this returns a copy of the list
    // we need to return a copy because we need to call a specific
    // method to alert all the listeners that the list has changed
    return [..._items];
  }

  List<Product> get favourites {
    return _items.where((elem) => elem.isFavourite).toList();
  }

  Product findProductById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchProducts() async {
    var productsMap = await Api().fetchProducts();
    _items = [];

    if(productsMap != null){
      productsMap.forEach((key, value) {
        var product = Product(
            id: key,
            name: value["name"],
            price: value["price"],
            description: value["description"],
            imageUrl: value["imageUrl"],
            isFavourite: value["isFavourite"]);
        _items.add(product);
      });
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    var productId = await Api().addProduct(product);

    product.id = productId;
    _items.add(product);
    notifyListeners();
  }

  Future<void> updateProduct(Product updatedProduct) async{
    var index = _items.indexWhere((element) => element.id == updatedProduct.id);
    if (index >= 0) {
      await Api().updateProduct(updatedProduct);
      _items[index] = updatedProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async{
    await Api().deleteProduct(id).then((_) {
        _items.removeWhere((product) => product.id == id);
        notifyListeners();
    });
  }
}
