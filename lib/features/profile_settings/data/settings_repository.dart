import 'package:glimpse/features/profile_settings/data/settings_service.dart';

class SettingsRepository {
  final SettingsService _settingsService;

  SettingsRepository({required SettingsService settingsService})
      : _settingsService = settingsService;

  Future<Map<String, dynamic>> updateUserStatus(int userId, String status) async {
    try {
      final response = await _settingsService.updateUserStatus(userId, status);
      return response;
    } catch (e) {
      print('Error updating user status: $e');
      throw Exception('Error updating user status: $e');
    }
  }
}
