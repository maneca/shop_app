import 'package:flutter/material.dart';
import 'package:shop_app/api/products_api.dart';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = []; //DUMMY_PRODUCTS;
  late ProductsApi _productsApi;
  final String? authToken;
  final String userId;

  List<Product> get items {
    // this returns a copy of the list
    // we need to return a copy because we need to call a specific
    // method to alert all the listeners that the list has changed
    return [..._items];
  }

  List<Product> get favourites {
    return _items.where((elem) => elem.isFavourite).toList();
  }

  Products(this.userId, this.authToken, this._items){
    _productsApi = ProductsApi();
  }

  Product findProductById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchProducts([bool filterByUser = false]) async {
    var productsMap = await _productsApi.fetchProducts(userId, filterByUser, authToken);
    List<Product> loadedProducts = [];

    if(productsMap != null){
      var userFavourites = await _productsApi.getUserFavourites(userId, authToken);

      productsMap.forEach((key, value) {
        var product = Product(
            id: key,
            name: value["name"],
            price: value["price"],
            description: value["description"],
            imageUrl: value["imageUrl"],
            isFavourite: userFavourites == null ? false : userFavourites[key] ?? false);
        loadedProducts.add(product);
      });
      _items = loadedProducts;
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    var productId = await _productsApi.addProduct(product, userId, authToken);

    product.id = productId;
    _items.add(product);
    notifyListeners();
  }

  Future<void> updateProduct(Product updatedProduct) async{
    var index = _items.indexWhere((element) => element.id == updatedProduct.id);
    if (index >= 0) {
      await _productsApi.updateProduct(updatedProduct, authToken);
      _items[index] = updatedProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async{
    await _productsApi.deleteProduct(id, authToken).then((_) {
        _items.removeWhere((product) => product.id == id);
        notifyListeners();
    });
  }
}
