import 'package:flutter/widgets.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/auth_api.dart';

class Auth with ChangeNotifier {
  String? _token = "";
  DateTime? _expireDate = DateTime.now();
  String? _userId = "";
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId == null ? "" : _userId!;
  }

  String? get token{
    if(_expireDate != null && _expireDate!.isAfter(DateTime.now())){
      return _token;
    }

    return null;
  }

  Future<void> signUp(String? email, String? password) async {
    var info = await AuthApi().signUp(email, password);
    _token = info.item1;
    _expireDate = info.item2;
    _userId = info.item3;
    _autoLogout();
    notifyListeners();
  }

  Future<void> login(String? email, String? password) async {
    var info = await AuthApi().login(email, password);

    _token = info.item1;
    _expireDate = info.item2;
    _userId = info.item3;
    _autoLogout();
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }

    final extractedUserData = json.decode(prefs.getString('userData')!);
    final expireDate = DateTime.parse(extractedUserData["expireDate"] as String);

    if(expireDate.isBefore(DateTime.now())){
      return false;
    }

    _userId = extractedUserData["userId"] as String?;
    _expireDate = DateTime.tryParse(extractedUserData["expireDate"]);
    _token = extractedUserData["token"] as String?;
    notifyListeners();
    _autoLogout();

    return true;
  }

  Future<void> logout() async{
    _userId = null;
    _expireDate = null;
    _token = null;

    if(_authTimer != null){
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("userData"); // or prefs.clear() to clear all shared preferences
  }

  void _autoLogout(){
    if(_authTimer != null){
      _authTimer!.cancel();
    }
    final timeToExpire = _expireDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }
}
