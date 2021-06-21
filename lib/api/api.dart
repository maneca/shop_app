import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/product.dart';
import '../models/cart_item.dart';
import '../models/http_exception.dart';

class Api{
  final String _baseUrl = "flutter-shop-app-e163c-default-rtdb.europe-west1.firebasedatabase.app";

  /********************************
              PRODUCTS
   ********************************/

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
    try {
      final url = Uri.https(_baseUrl, "/products/$id.json");
      var response = await http.delete(url);

      if (response.statusCode >= 400) {
        throw HttpException("Cannot delete product");
      }
    }catch(error){
      throw HttpException(error.toString());
    }
  }

  Future<void> updateFavourite(String id, bool isFavourite) async {
    try {
      final url = Uri.https(_baseUrl, "/products/" + id + ".json");
      var response = await http.patch(url, body: json.encode({
        'isFavourite': isFavourite
      }));

      if (response.statusCode >= 400) {
        throw HttpException("Cannot update product");
      }
    }catch(error){
      throw HttpException(error.toString());
    }
  }

  /********************************
              ORDERS
   ********************************/

  Future<String> addOrder(List<CartItem> products, double total, DateTime timestamp) async{
    try{
      final url = Uri.https(_baseUrl,"/orders.json");
      var response = await http.post(url, body: json.encode({
        "amount": total,
        "products": products.map((prod) => {
          'id': prod.id,
          'name': prod.name,
          'quantity': prod.quantity,
          'price': prod.price
        }).toList(),
        "dateTime": timestamp.toIso8601String()
      }));
      return json.decode(response.body)['name'];
    }catch(error){
      throw HttpException("Cannot add order");
    }
  }

  Future<Map<String, dynamic>> fetchOrders() async{
    try{
      final url = Uri.https(_baseUrl,"/orders.json");
      var response = await http.get(url);
      return json.decode(response.body) as Map<String, dynamic>;
    }catch(error){
      throw HttpException("Cannot fetch orders from web");
    }
  }
}