import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'dart:convert';
import '../providers/product.dart';

class Api{
  final String _baseUrl = "flutter-shop-app-e163c-default-rtdb.europe-west1.firebasedatabase.app";

  Future<String> addProduct(Product product) async{
    try{
      final url = Uri.https(_baseUrl,"/products.json");
      var response = await http.post(url, body: json.encode({
        'name': product.name,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isFavourite': product.isFavourite
      }));
      return json.decode(response.body)['name'];
    }catch(error){
      throw HttpException("Cannot add product");
    }
  }

  Future<Map<String, dynamic>> fetchProducts() async{
    try{
      final url = Uri.https(_baseUrl,"/products.json");
      var response = await http.get(url);
      return json.decode(response.body) as Map<String, dynamic>;
    }catch(error){
      throw HttpException("Cannot fetch products");
    }
  }

  Future<void> updateProduct(Product product) async{
    try{
      final url = Uri.https(_baseUrl, "/products/"+product.id+".json");
      await http.patch(url, body: json.encode({
        'name': product.name,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price
      }));
    }catch(error){
      throw HttpException("Cannot update product");
    }
  }

  Future<void> deleteProduct(String id) async{
      final url = Uri.https(_baseUrl, "/products/$id.json");
      var response = await http.delete(url);

      if(response.statusCode >= 400){
        throw HttpException("Cannot delete product");
      }
  }
}