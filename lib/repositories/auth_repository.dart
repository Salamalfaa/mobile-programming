import '../core/constants/api_constants.dart';
import '../core/network/api_exception.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthRepository {
  final ApiService _api;
  final StorageService _storage;

  AuthRepository(this._api, this._storage);

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _api.post(ApiConstants.register, {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
    return _saveSession(response.data as Map<String, dynamic>);
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.post(ApiConstants.login, {
      'email': email,
      'password': password,
      'device_name': 'perpus_app',
    });
    return _saveSession(response.data as Map<String, dynamic>);
  }

  Future<UserModel?> restoreSession() async {
    if (await _storage.getToken() == null) return null;
    try {
      final response = await _api.get(ApiConstants.me);
      final data = response.data as Map<String, dynamic>;
      return UserModel.fromJson(data['data'] as Map<String, dynamic>);
    } on ApiException catch (error) {
      if (error.statusCode == 401) {
        await _storage.clearToken();
        return null;
      }
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _api.post(ApiConstants.logout);
    } on ApiException {
      // Local logout must complete even while the server is unreachable.
    } finally {
      await _storage.clearToken();
    }
  }

  Future<UserModel> _saveSession(Map<String, dynamic> body) async {
    await _storage.saveToken(body['token'] as String);
    return UserModel.fromJson(body['user'] as Map<String, dynamic>);
  }
}
