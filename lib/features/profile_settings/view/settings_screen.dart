import 'package:flutter/material.dart';
import 'package:glimpse/features/authentication/view/authentication.dart';
import 'package:glimpse/features/common/data/models.dart';
import 'package:glimpse/features/authentication/domain/token_manager.dart';
import 'package:glimpse/features/profile_settings/view/set_status_screen.dart';

class Settings extends StatefulWidget {
  final User user;

  const Settings({Key? key, required this.user}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late String _status;
  String _selectedLanguage = 'Русский';

  @override
  void initState() {
    super.initState();
    _status = widget.user.status.isEmpty
        ? 'Здесь пусто...Добавьте статус!'
        : widget.user.status;
  }

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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              MediaQuery.of(context).padding.top,
          child: Center(
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
                ElevatedButton(
                  // Кнопка "Сменить аватарку"
                  onPressed: () {
                    // TODO: Implement change avatar functionality
                    print('Сменить аватарку tapped');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[700],
                    // Цвет фона кнопки
                    foregroundColor: Colors.white,
                    // Цвет текста кнопки
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    textStyle: TextStyle(
                        fontSize: 16,
                        fontFamily: "Raleway",
                        fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
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
                      GestureDetector(
                        onTap: () async {
                          // Открываем экран изменения статуса
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SetStatusScreen(
                                currentStatus: widget.user.status,
                                user: widget.user,
                                onStatusUpdated: (newStatus) {
                                  setState(() {
                                    _status = newStatus;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[900],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _status,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: "Raleway",
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Icon(
                                Icons.edit,
                                color: Colors.blueGrey[400],
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Язык:',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: "Raleway",
                            fontWeight: FontWeight.w600),
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
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Raleway",
                                      fontWeight: FontWeight.w600)),
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
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await deleteToken();
                      // После удаления токена перенаправляем на экран авторизации
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Authentication()),
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      // Красный цвет для кнопки выхода
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      textStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: "Raleway",
                          fontWeight: FontWeight.w600),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Выйти из профиля'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
