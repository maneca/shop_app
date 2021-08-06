import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../providers/product.dart';
import '../models/http_exception.dart';

class ProductsApi {
  final String _baseUrl =
      "flutter-shop-app-e163c-default-rtdb.europe-west1.firebasedatabase.app";

  Future<String> addProduct(
      Product product, String userId, String? authToken) async {
    try {
      final url = Uri.https(_baseUrl, "/products.json", {"auth": authToken});
      var response = await http.post(url,
          body: json.encode({
            'name': product.name,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId
          }));
      return json.decode(response.body)['name'];
    } catch (error) {
      throw HttpException("Cannot add product");
    }
  }

  Future<Map<String, dynamic>?> fetchProducts(String userId, bool filterByUser, String? authToken) async {
    try {
      var queryParams = filterByUser ?
      {
        "auth": authToken,
        "orderBy": '"creatorId"',
        "equalTo": '"$userId"'
      } :
      {
        "auth": authToken
      };
      final url = Uri.https(_baseUrl, "/products.json", queryParams);

      var response = await http.get(url);
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (error) {
      throw HttpException("Cannot fetch products");
    }
  }

  Future<void> updateProduct(Product product, String? authToken) async {
    try {
      final url = Uri.https(_baseUrl, "/products/" + product.id + ".json",
          {"auth": "$authToken"});
      await http.patch(url,
          body: json.encode({
            'name': product.name,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price
          }));
    } catch (error) {
      throw HttpException("Cannot update product");
    }
  }

  Future<void> deleteProduct(String id, String? authToken) async {
    try {
      final url =
          Uri.https(_baseUrl, "/products/$id.json", {"auth": "$authToken"});
      var response = await http.delete(url);

      if (response.statusCode >= 400) {
        throw HttpException("Cannot delete product");
      }
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<Map<String, dynamic>?> getUserFavourites(
      String userId, String? authToken) async {
    try {
      final url = Uri.https(
          _baseUrl, "/userFavourites/$userId.json", {"auth": "$authToken"});

      var response = await http.get(url);
      return response.body == "null"
          ? Map<String, dynamic>()
          : json.decode(response.body) as Map<String, dynamic>;
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<void> updateFavourite(
      String id, bool isFavourite, String userId, String? authToken) async {
    try {
      final url = Uri.https(
          _baseUrl, "/userFavourites/$userId/$id.json", {"auth": "$authToken"});
      var response = await http.put(url, body: json.encode(isFavourite));

      if (response.statusCode >= 400) {
        throw HttpException("Cannot update product");
      }
    } catch (error) {
      throw HttpException(error.toString());
    }
  }
}
