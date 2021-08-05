import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/cart_item.dart';
import '../models/http_exception.dart';

class OrdersApi{
  final String _baseUrl = "flutter-shop-app-e163c-default-rtdb.europe-west1.firebasedatabase.app";

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