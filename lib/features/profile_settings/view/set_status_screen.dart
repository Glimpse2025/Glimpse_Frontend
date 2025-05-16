import 'package:flutter/material.dart';
import 'package:glimpse/features/common/data/models.dart';
import 'package:glimpse/features/profile_settings/domain/set_status.dart';

class SetStatusScreen extends StatefulWidget {
  final Function(String) onStatusUpdated;
  final String currentStatus;
  final User user;

  const SetStatusScreen({
    Key? key,
    required this.onStatusUpdated,
    required this.currentStatus,
    required this.user,
  }) : super(key: key);

  @override
  _SetStatusScreenState createState() => _SetStatusScreenState();
}

class _SetStatusScreenState extends State<SetStatusScreen> {
  late SetStatus _controller;

  @override
  void initState() {
    super.initState();
    _controller = SetStatus();
    _controller.initWithCurrentStatus(widget.currentStatus);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Изменить статус',
          style: TextStyle(
            color: Colors.blueGrey[200],
            fontFamily: "Playball",
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller.statusController,
              style: TextStyle(color: Colors.white),
              maxLength: 100,
              decoration: InputDecoration(
                labelText: 'Ваш статус',
                labelStyle: TextStyle(color: Colors.blueGrey[200]),
                hintText: 'Введите новый статус',
                hintStyle: TextStyle(color: Colors.blueGrey[600]),
                filled: true,
                fillColor: Colors.blueGrey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.blueGrey[400]!),
                ),
              ),
            ),
            SizedBox(height: 20),
            ValueListenableBuilder<bool>(
              valueListenable: _controller.isLoading,
              builder: (context, isLoading, child) {
                return ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                    final success = await _controller.updateStatus(
                        context,
                        widget.user
                    );
                    if (success) {
                      widget.user.status = _controller.getStatusText();
                      widget.onStatusUpdated(_controller.getStatusText());
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[700],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontFamily: "Raleway",
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    disabledBackgroundColor: Colors.blueGrey[900],
                  ),
                  child: isLoading
                      ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : Text('Сохранить'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}