import 'dart:io';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:glimpse/Settings.dart';
import 'package:image_picker/image_picker.dart';
import 'package:glimpse/authentication.dart';

void main() => runApp(new AppStart());

class AppStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Glimpse",
      theme: ThemeData.dark(),
      home: Authentication(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? _image;
  double _opacity = 0.5;
  final ImagePicker _picker = ImagePicker();

  Future _getImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _opacity = 1.0;
        _uploadImage(_image!);
      } else {
        print('No image selected.');
        _opacity = 0.5;
      }
    });
  }

  Future<void> _uploadImage(File imageFile) async {
    // Замените на URL вашего API endpoint (бэкенда)
    final String apiUrl = 'http://your-backend-url/upload'; // Пример

    try {
      // Создаем multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Добавляем файл к request
      var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();

      var multipartFile = http.MultipartFile(
        'image', // Ключ должен соответствовать тому, что ожидает бэкенд
        stream,
        length,
        filename: imageFile.path.split('/').last,
      );

      request.files.add(multipartFile);

      // Отправляем request
      var response = await request.send();

      if (response.statusCode == 200) {
        // Обрабатываем успешный ответ
        var responseString = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseString);
        print('Изображение успешно загружено. Ответ: $jsonResponse');
        // Здесь можно обновить UI, сохранить URL из ответа и т.д.

        // Пример получения URL из ответа (если бэкенд его возвращает)
        String? imageUrl = jsonResponse['image_url'];
        if (imageUrl != null) {
          // Сохраняем URL в базу данных или используем для отображения
        }

      } else {
        // Обрабатываем ошибку
        print('Ошибка загрузки изображения: ${response.statusCode}');
      }
    } catch (e) {
      // Обрабатываем исключения
      print('Произошла ошибка при отправке запроса: $e');
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
                    color: Colors.blueGrey[200], fontFamily: "Playball", fontSize: 50),
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
                      backgroundImage: AssetImage('assets/images/user_icon.jpg'),
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
                      style: TextStyle(color: Colors.white, fontFamily: "Raleway", fontSize: 16, fontWeight: FontWeight.w600),
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

  final _biggerFont = const TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: "Raleway",fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.black,
        title: Text('Friends', style: TextStyle(color: Colors.blueGrey[200], fontFamily: "Playball", fontSize: 30)),
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