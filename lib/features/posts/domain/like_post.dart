import 'dart:io';

import 'package:flutter/material.dart';
import 'package:glimpse/features/common/data/models.dart';
import 'package:glimpse/features/common/di/service_locator.dart';
import 'package:glimpse/features/posts/data/posts_repository.dart';

final PostsRepository _postsRepository = getIt<PostsRepository>();

Future<void> likePost(int postID, int userId) async {
  try {
    return await _postsRepository.likePost(postID, userId);
  } catch (e) {
    print('Error liking post: $e');
    throw Exception('Error liking post: $e');
  }
}

Future<void> unlikePost(int postID, int userId) async {
  try {
    return await _postsRepository.unlikePost(postID, userId);
  } catch (e) {
    print('Error unliking post: $e');
    throw Exception('Error unliking post: $e');
  }
}

