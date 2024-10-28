import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  User? _user;

  String? get token => _token;
  User? get user => _user;

  bool get isAuth {
    if (_token == null) return false;
    return !Jwt.isExpired(_token!);
  }

  Future<void> signin(String username, String password) async {
    try {
      String token = await AuthServices().signin(username, password);
      setToken(token);
    } catch (e) {
      print(e);
    }
  }

  Future<void> signup(String username, String password) async {
    try {
      String token = await AuthServices().signup(username, password);
      setToken(token);
    } catch (e) {
      print(e);
    }
  }

  Future<void> signout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    _token = null;
    _user = null;
    notifyListeners();
  }

  Future<void> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    _token = token;
    _decodeToken(token);
    notifyListeners();
  }

  Future<void> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loadedToken = prefs.getString('token');
    print(loadedToken);

    if (loadedToken == null) return;
    setToken(loadedToken);

    notifyListeners();
  }

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    if (_token != null && !Jwt.isExpired(_token!)) {
      _decodeToken(_token!);
    }
    notifyListeners();
  }

  void _decodeToken(String token) {
    Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
    _user = User.fromJson(decodedToken);
  }
}
