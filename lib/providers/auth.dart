import 'package:flutter/widgets.dart';
import '../api/auth_api.dart';

class Auth with ChangeNotifier {
  String _token = "";
  DateTime _expireDate = DateTime.now();
  String _userId = "";

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String? get token{
    if(_expireDate.isAfter(DateTime.now())){
      return _token;
    }

    return null;
  }

  Future<void> signUp(String? email, String? password) async {
    var info = await AuthApi().signUp(email, password);
    _token = info.item1;
    _expireDate = info.item2;
    _userId = info.item3;

    notifyListeners();
  }

  Future<void> login(String? email, String? password) async {
    var info = await AuthApi().login(email, password);

    _token = info.item1;
    _expireDate = info.item2;
    _userId = info.item3;

    notifyListeners();
  }
}
