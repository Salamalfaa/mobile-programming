import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, String> fieldErrors;

  const ApiException(
    this.message, {
    this.statusCode,
    this.fieldErrors = const {},
  });

  factory ApiException.fromDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException('Server tidak merespons. Coba lagi nanti.');
      case DioExceptionType.connectionError:
        return const ApiException(
          'Tidak dapat terhubung ke server. Pastikan backend sudah berjalan.',
        );
      default:
        break;
    }

    final status = error.response?.statusCode;
    final data = error.response?.data;
    final fields = <String, String>{};
    String? serverMessage;

    if (data is Map) {
      if (data['message'] is String) {
        serverMessage = data['message'] as String;
      }
      final errors = data['errors'];
      if (errors is Map) {
        errors.forEach((key, value) {
          if (value is List && value.isNotEmpty) {
            fields[key.toString()] = value.first.toString();
          } else if (value is String) {
            fields[key.toString()] = value;
          }
        });
      }
    }

    final message = switch (status) {
      401 => 'Sesi berakhir. Silakan login kembali.',
      403 => 'Anda tidak memiliki akses.',
      404 => 'Data tidak ditemukan.',
      422 =>
        fields.isNotEmpty
            ? fields.values.first
            : (serverMessage ?? 'Data tidak valid.'),
      429 => 'Terlalu banyak percobaan. Tunggu sebentar lalu coba lagi.',
      final code? when code >= 500 => 'Terjadi kesalahan pada server ($code).',
      _ => serverMessage ?? 'Terjadi kesalahan tak terduga.',
    };

    return ApiException(message, statusCode: status, fieldErrors: fields);
  }

  @override
  String toString() => message;
}
