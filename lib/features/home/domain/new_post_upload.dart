import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:glimpse/features/common/data/models.dart';
import 'package:glimpse/features/common/di/service_locator.dart';
import 'package:glimpse/features/posts/data/post_repository.dart';
import 'package:glimpse/features/common/domain/useful_methods.dart';

final PostRepository _postRepository = getIt<PostRepository>();

Future<void> uploadImageToServer(File? _image, User _user, BuildContext context) async {
  try {
    final imageUrl = await _postRepository.uploadImage(_image!, _user.userId);

    if (imageUrl != null) {
      print('Изображение успешно загружено: $imageUrl');
    } else {
      print('Не удалось получить URL изображения');
      showErrorMessage('Не удалось загрузить изображение', context);
    }
  } catch (e) {
    // Обработка ошибок
    print('Ошибка при загрузке изображения или при получении user_id: $e');
    showErrorMessage('Ошибка при загрузке на сервер: $e', context);
  }
}