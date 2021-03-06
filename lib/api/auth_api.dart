import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/tuple.dart';
import '../models/http_exception.dart';

class AuthApi {

  Future<Tuple<String, DateTime, String>> _authenticate(String? email, String? password, String type) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$type?key=AIzaSyBWEpBZxsXGGAAv8UrlvA2bvgIOkbF-Y8M');

    try{
      var response = await http.post(url, body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true
      }));

      var responseData = json.decode(response.body);

      if(responseData['error'] != null){
        throw HttpException(responseData['error']['message']);
      }

      var _token = responseData['idToken'];
      var _userId = responseData['localId'];
      var _expireDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({'token': _token, "userId": _userId, 'expireDate': _expireDate.toIso8601String()});
      prefs.setString('userData', userData);

      return Tuple(item1: _token, item2: _expireDate, item3: _userId);
    }catch (error){
      throw error;
    }
  }

  Future<Tuple<String, DateTime, String>> signUp(String? email, String? password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<Tuple<String, DateTime, String>> login(String? email, String? password) async {
    return _authenticate(email, password, "signInWithPassword");
  }
}
