import 'package:flutter/material.dart';
import 'package:glimpse/main.dart';

class Authentication extends StatelessWidget {
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
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Почта',
                  labelStyle: TextStyle(color: Colors.blueGrey[200]),
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  labelStyle: TextStyle(color: Colors.blueGrey[200]),
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement login logic
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
                child: Text('Войти', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[700],
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // TODO: Implement registration logic
                },
                child: Text('Зарегистрироваться', style: TextStyle(color: Colors.blueGrey[200])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
