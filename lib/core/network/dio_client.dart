import 'package:dio/dio.dart';

import '../../services/storage_service.dart';
import '../constants/api_constants.dart';

class DioClient {
  static Dio build(StorageService storage, {void Function()? onUnauthorized}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final hasToken = error.requestOptions.headers.containsKey(
            'Authorization',
          );
          final path = error.requestOptions.path;
          if (error.response?.statusCode == 401 &&
              hasToken &&
              path != ApiConstants.logout &&
              path != ApiConstants.me) {
            await storage.clearToken();
            onUnauthorized?.call();
          }
          handler.next(error);
        },
      ),
    );

    return dio;
  }
}
