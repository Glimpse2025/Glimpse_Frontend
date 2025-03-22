import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:glimpse/Settings.dart';
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

class MyApp extends StatelessWidget {
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
            mainAxisSize: MainAxisSize.min, // Занимать минимум места
            mainAxisAlignment: MainAxisAlignment.center, // Центрировать по горизонтали
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
        body: Column(  // Используем Column, чтобы разместить окошко и ListView друг под другом
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      'assets/images/selfie.jpg',
                      width: 170,
                      height: 300,
                      fit: BoxFit.cover,
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
          ], //children
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