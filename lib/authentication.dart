import 'package:flutter/material.dart';
import 'package:glimpse/ApiClient.dart';
import 'package:glimpse/main.dart';
import 'package:glimpse/registry.dart';
import 'package:glimpse/token_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError("Пожалуйста, заполните все поля.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Используйте ApiClient для вызова API
      final response = await ApiClient.apiService.login(email, password);

      if (response.containsKey('token')) {
        // Аутентификация прошла успешно
        final String token = response['token'];

        // Сохранение токена
        await saveToken(token);

        // Переход на главный экран
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
      } else {
        // Аутентификация не удалась
        _showError(response['message'] ?? "Неверная почта или пароль.");
      }
    } catch (error) {
      print("Error during login: $error");
      _showError("Ошибка при подключении к серверу.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Welcome to Glimpse!",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.blueGrey[200],
                  fontFamily: "Playball",
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Почта',
                  labelStyle: TextStyle(color: Colors.blueGrey[200]),
                  border: const OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  labelStyle: TextStyle(color: Colors.blueGrey[200]),
                  border: const OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[700],
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Войти',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Registry()),
                  );
                },
                child: const Text(
                  'Зарегистрироваться',
                  style: TextStyle(color: Color(0xFFB0BEC5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
