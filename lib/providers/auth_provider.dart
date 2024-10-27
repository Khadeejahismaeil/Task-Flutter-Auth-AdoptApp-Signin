import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  User? _user;

  String? get token => _token;
  User? get user => _user;

  bool get isAuth {
    if (_token == null) return false;
    return !JwtDecoder.isExpired(_token!);
  }

  Future<void> signin(Map<String, String> user) async {
    try {
      String token = await AuthServices().signin(user);
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

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    if (_token != null && !JwtDecoder.isExpired(_token!)) {
      _decodeToken(_token!);
    }
    notifyListeners();
  }

  void _decodeToken(String token) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    _user = User.fromJson(decodedToken);
  }
}
