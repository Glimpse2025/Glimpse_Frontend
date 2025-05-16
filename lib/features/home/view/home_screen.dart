import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:glimpse/features/common/data/api_client.dart';
import 'package:glimpse/features/common/data/models.dart';
import 'package:glimpse/features/common/domain/useful_methods.dart';
import 'package:glimpse/features/home/domain/load_user_data.dart';
import 'package:glimpse/features/profile_settings/view/settings_screen.dart';
import 'package:glimpse/features/authentication/domain/token_manager.dart';
import 'package:glimpse/features/home/domain/new_post_upload.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> implements UserState {
  User? _user;

  @override
  set user(User value) {
    setState(() {
      _user = value;
    });
  }

  @override
  void updateLoadingState(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData(context, this);
  }

  File? _image;
  double _opacity = 0.5;
  final ImagePicker _picker = ImagePicker();

  Future _getImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _opacity = 1.0;
        uploadImageToServer(_image!, _user!, context);
      } else {
        print('No image selected.');
        _opacity = 0.5;
      }
    });
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
                      MaterialPageRoute(
                          builder: (context) => Settings(user: _user!)),
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
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Friends',
                style: TextStyle(
                    color: Colors.blueGrey[200],
                    fontFamily: "Playball",
                    fontSize: 30),
              ),
            ),
          ),
          if (_user != null)
            Expanded(
              child: _user != null
                  ? FriendList(userId: _user!.userId)
                  : Center(child: Text('Загрузка данных пользователя...')),
            ),
          if (_user == null)
            Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
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
          showErrorMessage('Ошибка при загрузке списка друзей', context);
        }
      } catch (e) {
        print('Error loading friends: $e');
        showErrorMessage('Ошибка при загрузке списка друзей: $e', context);
      }
    } else {
      /// Handle no token case
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (_friends.isEmpty) {
      return Center(
        child: Text(
          'No friends yet.',
          style: TextStyle(color: Colors.white),
        ),
      );
    } else {
      return _buildFriendList();
    }
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
