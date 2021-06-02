import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/product.dart';

class Api{
  String _backendUrl;

  Api(){
    _backendUrl = "flutter-shop-app-e163c-default-rtdb.europe-west1.firebasedatabase.app";
  }

  Future<String> addProduct(Product product) async{
    final url = Uri.https(_backendUrl,"/products.json");
    var response = await http.post(url, body: json.encode({
      'name': product.name,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'isFavourite': product.isFavourite
    }));

    return json.decode(response.body)['name'];
  }

}