import 'package:flutter/material.dart';
import 'package:glimpse/features/common/data/models.dart';
import 'package:glimpse/features/common/di/service_locator.dart';
import 'package:glimpse/features/profile_settings/data/settings_repository.dart';
import 'package:glimpse/features/common/domain/useful_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetStatus {
  final TextEditingController statusController = TextEditingController();
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final SettingsRepository _settingsRepository = getIt<SettingsRepository>();

  void initWithCurrentStatus(String currentStatus) {
    statusController.text = currentStatus;
  }

  void dispose() {
    statusController.dispose();
    isLoading.dispose();
  }

  Future<bool> updateStatus(BuildContext context, User _user) async {
    if (statusController.text.trim().isEmpty) {
      showErrorMessage('Статус не может быть пустым', context);
      return false;
    }

    isLoading.value = true;

    try {
      final response = await _settingsRepository.updateUserStatus(
          _user.userId, statusController.text.trim());
      isLoading.value = false;
      return true;
    } catch (e) {
      print('Error setting status: $e');
      showErrorMessage('Ошибка: ${e.toString()}', context);
      isLoading.value = false;
      return false;
    }
  }

  String getStatusText() {
    return statusController.text.trim();
  }
}
