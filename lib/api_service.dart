import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://127.0.0.1:5000/api';

  Future<List<Post>> getPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Post> posts = body.map((dynamic item) => Post.fromJson(item)).toList();
      return posts;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Post?> getPost(int postId) async {
    final response = await http.get(Uri.parse('$baseUrl/posts/$postId'));

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Post post = Post.fromJson(body);
      return post;
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Post?> createPost(int userId, String imagePath, String? caption) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'user_id': userId,
        'image_path': imagePath,
        'caption': caption,
      }),
    );

    if (response.statusCode == 201) {
      Map<String, dynamic> body = jsonDecode(response.body);
      // Создайте новый объект Post или верните null, если необходимо.
      return null; // В данном примере, API возвращает только сообщение об успехе
    } else {
      print('Failed to create post. Status code: ${response.statusCode}, body: ${response.body}');
      return null;
      //throw Exception('Failed to create post');
    }
  }


}

// Модель данных Post (соответствует структуре JSON, возвращаемой API)
class Post {
  final int postId;
  final int userId;
  final String imagePath;
  final String? caption;
  final String timestamp;

  Post({
    required this.postId,
    required this.userId,
    required this.imagePath,
    this.caption,
    required this.timestamp,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['post_id'],
      userId: json['user_id'],
      imagePath: json['image_path'],
      caption: json['caption'],
      timestamp: json['timestamp'],
    );
  }
}