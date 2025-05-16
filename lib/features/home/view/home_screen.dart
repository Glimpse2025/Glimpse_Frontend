import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:glimpse/features/common/data/api_client.dart';
import 'package:glimpse/features/authentication/view/authentication.dart';
import 'package:glimpse/features/common/data/models.dart';
import 'package:glimpse/features/common/di/service_locator.dart';
import 'package:glimpse/features/profile_settings/view/settings_screen.dart';
import 'package:glimpse/features/authentication/domain/token_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:glimpse/features/posts/domain/post_upload.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final token = await getToken();
    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('${ApiClient.baseUrl}/api/user'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          final userData = jsonDecode(response.body);
          setState(() {
            _user = User.fromJson(userData);
            _isLoading = false;
          });
        } else {
          print('Failed to load user data: ${response.statusCode}');
          // Обработайте ошибку, например, удалите токен и перенаправьте на страницу входа
          await deleteToken();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Authentication()),
          );
        }
      } catch (e) {
        print('Error loading user data: $e');
        // Обработайте ошибку подключения
      }
    } else {
      // Если токена нет, перенаправляем на страницу входа
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Authentication()),
      );
    }
  }

  File? _image;
  double _opacity = 0.5;
  final ImagePicker _picker = ImagePicker();
  final PostUpload _postUpload = getIt<PostUpload>();

  Future _getImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _opacity = 1.0;
        _uploadImageToServer();
      } else {
        print('No image selected.');
        _opacity = 0.5;
      }
    });
  }

  Future<void> _uploadImageToServer() async {
    try {
      final imageUrl = await _postUpload.uploadImage(_image!, _user!.userId);

      if (imageUrl != null) {
        print('Изображение успешно загружено: $imageUrl');
      } else {
        print('Не удалось получить URL изображения');
        _showErrorMessage('Не удалось загрузить изображение');
      }
    } catch (e) {
      // Обработка ошибок
      print('Ошибка при загрузке изображения или при получении user_id: $e');
      _showErrorMessage('Ошибка при загрузке на сервер: $e');
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.black,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Icon(
            Icons.search,
            color: Colors.blueGrey[200]!,
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Glimpse",
              style: TextStyle(
                  color: Colors.blueGrey[200],
                  fontFamily: "Playball",
                  fontSize: 50),
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Settings()),
                    );
                  },
                  child: CircleAvatar(
                    backgroundImage: _user?.profilePic != null
                        ? NetworkImage(_user!.profilePic!)
                        : const AssetImage('assets/images/user_icon.jpg'),
                    radius: 20,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blueGrey[400]!,
                  Colors.blueGrey[900]!,
                ],
              ),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: _getImage,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Opacity(
                      opacity: _opacity,
                      child: _image == null
                          ? Image.asset(
                        'assets/images/black_gradient.jpeg',
                        width: 170,
                        height: 300,
                        fit: BoxFit.cover,
                      )
                          : Image.file(
                        _image!,
                        width: 170,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Подпись к изображению',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Raleway",
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          if (_user!=null)
            Expanded(
              child: FriendList(userId: _user!.userId),
            ),
          if (_user==null)
            Spacer(
            ),
        ],
      ),
    );
  }
}

class FriendList extends StatefulWidget {
  final int userId;

  FriendList({required this.userId});

  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  List<User> _friends = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    final token = await getToken();
    if (token != null) {
      try {
        // Use the passed userId instead of hardcoded one
        final response = await http.get(
          Uri.parse('${ApiClient.baseUrl}/api/friends/${widget.userId}'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          final List<dynamic> friendsData = jsonDecode(response.body);
          setState(() {
            _friends = friendsData.map((json) => User.fromJson(json)).toList();
            _isLoading = false;
          });
        } else {
          print('Failed to load friends: ${response.statusCode}');
          // Handle error appropriately
        }
      } catch (e) {
        print('Error loading friends: $e');
        // Handle error appropriately
      }
    } else {
      /// Handle no token case
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.black,
        title: Text('Friends',
            style: TextStyle(
                color: Colors.blueGrey[200],
                fontFamily: "Playball",
                fontSize: 30)),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _friends.isEmpty
          ? Center(
        child: Text(
          'No friends yet.',
          style: TextStyle(color: Colors.white),
        ),
      )
          : _buildFriendList(),
    );
  }

  Widget _buildFriendList() {
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: _friends.length,
      itemBuilder: (context, i) {
        return _buildFriendRow(_friends[i]);
      },
    );
  }

  Widget _buildFriendRow(User friend) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: friend.profilePic != null
            ? NetworkImage(friend.profilePic!)
            : AssetImage('assets/images/user_icon.jpg') as ImageProvider,
        radius: 18,
      ),
      title: Text(friend.username ?? 'Unknown',
          style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontFamily: "Raleway",
              fontWeight: FontWeight.w600)),
      trailing: CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage('assets/images/bell.png'),
        radius: 18,
      ),
    );
  }
}
