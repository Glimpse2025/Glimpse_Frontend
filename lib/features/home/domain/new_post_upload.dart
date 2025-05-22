import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:glimpse/features/common/data/models.dart';
import 'package:glimpse/features/common/di/service_locator.dart';
import 'package:glimpse/features/posts/data/post_repository.dart';
import 'package:glimpse/features/common/domain/useful_methods.dart';

final PostRepository _postRepository = getIt<PostRepository>();

Future<void> uploadImageToServer(File? _image, User _user, BuildContext context) async {
  try {
    final postID = await _postRepository.uploadImage(_image!, _user.userId);

    if (postID != null) {
      print('Пост успешно опубликован с id: $postID');
    } else {
      print('Не удалось получить id поста');
      showErrorMessage('Не удалось выложить пост', context);
    }
  } catch (e) {
    print('Ошибка при загрузке изображения или при опубликовании поста: $e');
    showErrorMessage('Ошибка при загрузке на сервер: $e', context);
  }
}