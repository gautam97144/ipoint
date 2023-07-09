import 'package:dio/dio.dart';

class ApiClient {
   final Dio dio = Dio(
      BaseOptions(
    baseUrl: 'https://irs.rivaaninfotech.com/api/',
    connectTimeout: 50000,
    receiveTimeout: 50000,
  ));
}
