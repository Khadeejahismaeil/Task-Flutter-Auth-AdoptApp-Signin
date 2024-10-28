import 'package:adopt_app/models/user.dart';
import 'package:dio/dio.dart';

class AuthServices {
  final Dio dio = Dio();
  final _baseUrl = 'https://coded-pets-api-auth.eapi.joincoded.com';

  Future<String> signin(String username, String password) async {
    try {
      Response response = await dio.post('$_baseUrl/signin',
          data: {'username': username, 'password': password});
      return response.data['token'];
    } catch (e) {
      rethrow;
    }
  }

  Future<String> signup(String username, String password) async {
    late String token;
    try {
      Response response = await dio.post('$_baseUrl/signup',
          data: {'username': username, 'password': password});
      token = response.data['token'];
    } on DioError catch (error) {
      print(error);
    }
    return token;
  }
}
