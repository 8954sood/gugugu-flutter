import 'package:dio/dio.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: 'http://localhost:8080',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    )).. interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        logPrint: print,
        ),
    );
  }
} 