import 'package:flutter/material.dart';
import 'package:glimpse/features/authentication/domain/token_manager.dart';
import 'package:glimpse/features/authentication/view/authentication.dart';
import 'package:glimpse/features/common/data/models.dart';
import 'package:glimpse/features/common/di/service_locator.dart';
import 'package:glimpse/features/home/data/home_page_repository.dart';

final HomePageRepository _homePageRepository = getIt<HomePageRepository>();

Future<void> loadUserData(BuildContext context, [UserState? state]) async {
  final token = await getToken();
  if (token != null) {
    try {
      final userData = await _homePageRepository.getUserData();

      if (state != null) {
        state.user = User.fromJson(userData);
        state.updateLoadingState(false);
      }
    } catch (e) {
      print('Error loading user data: $e');
      await deleteToken();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Authentication()),
        (route) => false,
      );
    }
  } else {
    // Если токена нет, перенаправляем на страницу входа
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Authentication()),
    );
  }
}
