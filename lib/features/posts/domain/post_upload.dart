import 'dart:io';
import 'package:glimpse/features/posts/data/post_repository.dart';

class PostUpload {
  final PostRepository _postRepository;

  PostUpload({required PostRepository postRepository}) : _postRepository = postRepository;

  Future<String?> uploadImage(File imageFile, int userId) async {
    try {
      return await _postRepository.uploadImage(imageFile, userId);
    } catch (e) {
      return null;
    }
  }
}