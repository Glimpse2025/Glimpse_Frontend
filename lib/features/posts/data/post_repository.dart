import 'dart:io';
import 'package:glimpse/features/posts/data/posts_service.dart';

class PostRepository {
  final PostsService _postsService;

  PostRepository({required PostsService postsService}) : _postsService = postsService;

  Future<String?> uploadImage(File imageFile, int userId) async {
    try {
      final response = await _postsService.uploadImage(imageFile.path, userId);

      if (response.containsKey('image_url')) {
        // Сохранение прошло успешно
        return response['image_url'];
      }
      return null;
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Error uploading image: $e');
    }
  }
}
