import 'package:flutter/material.dart';
import 'package:glimpse/features/authentication/view/authentication.dart';
import 'package:glimpse/features/home/home_screen.dart';
import 'package:glimpse/token_manager.dart';

void main() => runApp(AppStart());

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
            return HomeScreen();
          } else {
            // Если нет токена, на Authentication
            return Authentication();
          }
        },
      ),
    );
  }
}

