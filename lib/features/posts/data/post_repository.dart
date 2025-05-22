import 'dart:io';
import 'dart:typed_data' show Uint8List;
import 'package:glimpse/features/common/data/models.dart';
import 'package:glimpse/features/posts/data/posts_service.dart';
import 'package:path_provider/path_provider.dart';

class PostRepository {
  final PostsService _postsService;

  PostRepository({required PostsService postsService}) : _postsService = postsService;

  Future<int?> uploadImage(File imageFile, int userId) async {
    final response1;
    try {
      response1 = await _postsService.uploadImage(imageFile.path, userId);
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Error uploading image: $e');
    }
    try {
      final response2 = await _postsService.createPost(userId, response1['image_url'], null);

      if (response2.containsKey('post_id')) {
        // Сохранение прошло успешно
        return response2['post_id'];
      }
      return null;
    } catch (e) {
      print('Error creating post: $e');
      throw Exception('Error creating post: $e');
    }
  }

  Future<Post?> getUserPost(int userId) async {
    try {
      final List<dynamic> posts = await _postsService.getUserPost(userId);

      if (posts.isNotEmpty) {
        final Map<String, dynamic> postData = posts[0];
        return Post.fromJson(postData);
      }
      return null;
    } catch (e) {
      print('Error getting post: $e');
      throw Exception('Error getting post: $e');
    }
  }

  Future<File> getImageAsFile(String imagePath) async {
    final Uint8List bytes = await _postsService.getImage(imagePath);

    // Создаем временный файл
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');

    // Записываем байты в файл
    return await tempFile.writeAsBytes(bytes);
  }
}
