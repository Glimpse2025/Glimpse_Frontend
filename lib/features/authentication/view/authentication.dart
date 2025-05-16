import 'package:flutter/material.dart';
import 'package:glimpse/features/common/data/api_client.dart';
import 'package:glimpse/features/authentication/view/registry.dart';
import 'package:glimpse/features/home/view/home_screen.dart';
import 'package:glimpse/features/authentication/domain/token_manager.dart';
import 'package:glimpse/features/common/domain/useful_methods.dart';

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
      showErrorMessage("Пожалуйста, заполните все поля.", context);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Используйте ApiClient для вызова API
      final response = await ApiClient.authenticationService.login(email, password);

      if (response.containsKey('token')) {
        // Аутентификация прошла успешно
        final String token = response['token'];

        // Сохранение токена
        await saveToken(token);

        // Переход на главный экран
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false,
        );
      } else {
        showErrorMessage(response['error'] ?? "Неверная почта или пароль.", context);
      }
    } catch (error) {
      print("Error during login: $error");
      showErrorMessage("Аккаунта не существует или проблемы с подключением к серверу", context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                  Navigator.pushReplacement(
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
