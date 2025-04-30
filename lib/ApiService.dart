import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  // Общая функция для GET запросов
  Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data from $endpoint. Status code: ${response.statusCode}, body: ${response.body}');
    }
  }

  // Общая функция для POST запросов
  Future<dynamic> post(String endpoint, dynamic body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to post data to $endpoint. Status code: ${response.statusCode}, body: ${response.body}');
    }
  }

  // Общая функция для PUT запросов
  Future<dynamic> put(String endpoint, dynamic body) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update data at $endpoint. Status code: ${response.statusCode}, body: ${response.body}');
    }
  }

  // Общая функция для DELETE запросов
  Future<dynamic> delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$baseUrl/$endpoint'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete data at $endpoint. Status code: ${response.statusCode}, body: ${response.body}');
    }
  }

  // Методы API для каждой конечной точки
  Future<Map<String, dynamic>> registry(String email, String password, String username) async {
    return await post('api/registry', {'email': email, 'password': password, 'username': username});
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    return await post('api/login', {'email': email, 'password': password});
  }

  Future<Map<String, dynamic>> createUser(String username, String password, String email, String profilePic, String status) async {
    return await post('api/users', {'username': username, 'password': password, 'email': email, 'profile_pic': profilePic, 'status': status});
  }

  Future<Map<String, dynamic>> updateUserStatus(int userId, String status) async {
    return await put('api/users/$userId/status', {'status': status});
  }

  Future<Map<String, dynamic>> createPost(int userId, String imagePath, String caption) async {
    return await post('api/posts', {'user_id': userId, 'image_path': imagePath, 'caption': caption});
  }

  Future<Map<String, dynamic>> addFriend(int userId, int friendId) async {
    return await post('api/friends', {'user_id': userId, 'friend_id': friendId});
  }

  Future<Map<String, dynamic>> addComment(int postId, int userId, String text) async {
    return await post('api/comments', {'post_id': postId, 'user_id': userId, 'text': text});
  }

  Future<Map<String, dynamic>> likePost(int postId, int userId) async {
    return await post('api/likes', {'post_id': postId, 'user_id': userId});
  }

  Future<List<dynamic>> getUserPosts(int userId) async {
    return await get('api/users/$userId/posts');
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

}