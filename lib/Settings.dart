import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String _status = 'Добавьте статус';
  String _selectedLanguage = 'Русский';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings',
            style: TextStyle(
                color: Colors.blueGrey[200],
                fontFamily: "Playball",
                fontSize: 30)),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // Выравнивание вверху
          crossAxisAlignment: CrossAxisAlignment.center,
          // Центрирование по горизонтали
          children: [

            SizedBox(height: 20),

            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/user_icon.jpg'),
            ),

            SizedBox(height: 10),

            ElevatedButton( // Кнопка "Сменить аватарку"
              onPressed: () {
                // TODO: Implement change avatar functionality
                print('Сменить аватарку tapped');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[700], // Цвет фона кнопки
                foregroundColor: Colors.white, // Цвет текста кнопки
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: TextStyle(fontSize: 16, fontFamily: "Raleway", fontWeight: FontWeight.w600),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Сменить аватарку'),
            ),

            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Статус:',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "Raleway",
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[900],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    child: Text(
                      _status,
                      style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Raleway", fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Язык:',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "Raleway",
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[900],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: DropdownButton<String>(
                      dropdownColor: Colors.blueGrey[900],
                      value: _selectedLanguage,
                      items: <String>['Русский', 'Английский']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: TextStyle(color: Colors.white, fontFamily: "Raleway", fontWeight: FontWeight.w600)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedLanguage = newValue!;
                        });
                      },
                      style: TextStyle(color: Colors.white),
                      underline: Container(),
                      // Убираем подчеркивание
                      isExpanded: true, // Занимает всю доступную ширину
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
