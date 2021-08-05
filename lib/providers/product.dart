import 'package:flutter/foundation.dart';
import '../api/products_api.dart';

class Product with ChangeNotifier{
  String id;
  String name;
  String description;
  double price;
  String imageUrl;
  bool isFavourite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavourite = false
  });

  Future<void> toggleFavourite() async{
    isFavourite = !isFavourite;
    await ProductsApi().updateFavourite(id, isFavourite);

    notifyListeners();
  }
}