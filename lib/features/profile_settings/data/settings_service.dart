import 'package:glimpse/features/common/data/api_service.dart';

class SettingsService extends ApiService {
  SettingsService({required super.baseUrl});

  Future<Map<String, dynamic>> updateUserStatus(
      int userId, String status) async {
    return await put('api/users/$userId/status', {'status': status});
  }
}
