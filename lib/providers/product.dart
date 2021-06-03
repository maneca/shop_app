import 'package:flutter/foundation.dart';

class Product with ChangeNotifier{
  String id;
  String name;
  String description;
  double price;
  String imageUrl;
  bool isFavourite;

  Product({
    this.id,
    @required this.name,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false
  }){
    this.id = DateTime.now().toString();
  }

  void toggleFavourite(){
    isFavourite = !isFavourite;
    notifyListeners();
  }
}