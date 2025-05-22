import 'package:glimpse/features/common/data/api_service.dart';
import 'dart:typed_data' show Uint8List;

class PostsService extends ApiService {
  PostsService({required super.baseUrl});

  Future<Map<String, dynamic>> createPost(
      int userId, String imagePath, String? caption) async {
    return await post('api/posts',
        {'user_id': userId, 'image_url': imagePath, 'caption': caption});
  }

  Future<Map<String, dynamic>> updatePostCaption(
      int postId, String caption) async {
    return await put('api/posts/$postId/caption', {'caption': caption});
  }

  Future<Map<String, dynamic>> addComment(
      int postId, int userId, String text) async {
    return await post(
        'api/comments', {'post_id': postId, 'user_id': userId, 'text': text});
  }

  Future<Map<String, dynamic>> likePost(int postId, int userId) async {
    return await post('api/likes', {'post_id': postId, 'user_id': userId});
  }

  Future<List<dynamic>> getUserPost(int userId) async {
    return await get('api/users/$userId/post');
  }

  Future<List<dynamic>> getFriendsPosts(int userId) async {
    return await get('api/friends/$userId/posts');
  }

  Future<List<dynamic>> getPostComments(int postId) async {
    return await get('api/posts/$postId/comments');
  }

  Future<Map<String, dynamic>> getPostLikesCount(int postId) async {
    return await get('api/posts/$postId/likes/count');
  }

  Future<Map<String, dynamic>> uploadImage(String imagePath, int userId) async {
    return await uploadFile('api/upload/$userId', imagePath);
  }

  Future<Uint8List> getImage(String imagePath) async {
    return await getImageFile(imagePath);
  }
}
