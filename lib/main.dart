import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:glimpse/ApiClient.dart';
import 'package:glimpse/Settings.dart';
import 'package:glimpse/models.dart';
import 'package:glimpse/token_manager.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:glimpse/authentication.dart';

void main() => runApp(new AppStart());

class AppStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Glimpse",
      theme: ThemeData.dark(),
      home: FutureBuilder<String?>(
        // Используем FutureBuilder
        future: getToken(), // Получаем токен асинхронно
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Пока ждем, показываем индикатор загрузки
          } else if (snapshot.hasData && snapshot.data != null) {
            // Если есть токен, переходим на MyApp
            return MyApp();
          } else {
            // Если нет токена, на Authentication
            return Authentication();
          }
        },
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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

  Future _getImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _opacity = 1.0;
        uploadImage(_image!);
      } else {
        print('No image selected.');
        _opacity = 0.5;
      }
    });
  }

  Future<String?> uploadImage(File imageFile) async {
    var uri = Uri.parse("${ApiClient.baseUrl}/api/upload");

    // Создаем multipart request
    var request = http.MultipartRequest("POST", uri);

    // Добавляем файл к request
    var multipartFile = await http.MultipartFile.fromPath(
      'image', // Ключ должен соответствовать тому, что ожидает backend
      imageFile.path,
    );

    request.files.add(multipartFile);

    // Отправляем request
    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        // Получаем тело ответа
        var responseString = await response.stream.bytesToString();
        // Декодируем JSON
        var jsonResponse = jsonDecode(responseString);
        // Получаем URL изображения
        return jsonResponse[
            'image_url']; // Ключ должен соответствовать тому, что возвращает backend
      } else {
        print('Ошибка загрузки изображения: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Ошибка отправки запроса: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "List in Flutter",
      theme: ThemeData.dark(),
      home: new Scaffold(
        appBar: AppBar(
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.black,
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
            Expanded(
              child: RandomWords(),
            ),
          ],
        ),
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RandomWordsState();
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];

  final _biggerFont = const TextStyle(
      fontSize: 18.0,
      color: Colors.white,
      fontFamily: "Raleway",
      fontWeight: FontWeight.w600);

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
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();

        final index = i ~/ 2;
        // If you've reached the end of the available word pairings...
        if (index >= _suggestions.length) {
          // ...then generate 10 more and add them to the suggestions list.
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    return new ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage('assets/images/user_icon.jpg'),
        radius: 18,
      ),
      title: new Text(pair.asPascalCase, style: _biggerFont),
      trailing: CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage('assets/images/bell.png'),
        radius: 18,
      ),
    );
  }
}
