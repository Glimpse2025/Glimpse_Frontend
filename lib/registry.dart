import 'package:flutter/material.dart';
import 'package:glimpse/authentication.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Registry extends StatefulWidget {
  @override
  _RegistryState createState() => _RegistryState();
}

class _RegistryState extends State<Registry> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose(); // Dispose
    super.dispose();
  }

  Future<void> _signin() async {
    setState(() {
      _isLoading = true;
    });

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String username = _usernameController.text.trim();

    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      _showError("Пожалуйста, заполните все поля.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final Uri apiUrl = Uri.parse('http://127.0.0.1:5000/api/registry');

    try {
      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'username': username,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        // Registration successful
        //final Map<String, dynamic> data = jsonDecode(response.body); // If expecting a body
        //final String token = data['token']; // If your backend returns a token on registration

        _showSuccess("Регистрация прошла успешно.  Войдите в свой аккаунт."); // Show success message

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Authentication()),
        );
      } else {
        // Registration failed
        print('Registration failed with status: ${response.statusCode}. Body: ${response.body}');

        Map<String, dynamic> errorResponse;
        try {
          errorResponse = jsonDecode(response.body);
          _showError(errorResponse['message'] ?? "Ошибка регистрации. Попробуйте еще раз.");
        } catch (e) {
          _showError("Ошибка регистрации.  Неверный формат ответа сервера.");
        }
      }
    } catch (error) {
      print("Error during registration: $error");
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

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
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
                "Create a Glimpse Account!",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.blueGrey[200],
                  fontFamily: "Playball",
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Имя пользователя',
                  labelStyle: TextStyle(color: Colors.blueGrey[200]),
                  border: const OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
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
                onPressed: _isLoading ? null : _signin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[700],
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'Зарегистрироваться',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
