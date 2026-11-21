import 'package:dio/dio.dart';

import '../core/network/api_exception.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<Response<dynamic>> post(String path, [Map<String, dynamic>? data]) =>
      _guard(() => _dio.post<dynamic>(path, data: data));

  Future<Response<dynamic>> get(String path, {Map<String, dynamic>? params}) =>
      _guard(() => _dio.get<dynamic>(path, queryParameters: params));

  Future<Response<dynamic>> put(String path, Map<String, dynamic> data) =>
      _guard(() => _dio.put<dynamic>(path, data: data));

  Future<Response<dynamic>> delete(String path) =>
      _guard(() => _dio.delete<dynamic>(path));

  Future<Response<dynamic>> _guard(
    Future<Response<dynamic>> Function() request,
  ) async {
    try {
      return await request();
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
