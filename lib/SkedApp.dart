import 'package:flutter/material.dart';
import 'package:flutter_sked/WeekPage.dart';

import 'DayPage.dart';
import 'e-rozklad_api.dart';

class SkedApp extends StatefulWidget {
  @override
  createState() => SkedAppState();
}

class SkedAppState extends State<SkedApp> {
  int _selectedIndex = 0;
  bool refreshEnabled = true;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Align(
            alignment: Alignment(-1.5, 0),
            child: Text(
              'Flutter - Sked',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),
          subtitle: Text('ІСД-41', style: TextStyle(color: Colors.white70)),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.loop),
            tooltip: 'Обновить расписание',
            onPressed: () async {
              if (refreshEnabled) {
                refreshEnabled = false;
                await ERozkladAPI.update();
                refreshEnabled = true;
              }
            },
          ),
          PopupMenuButton<int>(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("Перезайти"),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("О приложении"),
              ),
            ],
          ),
        ],
      ),
      body: _selectedIndex == 0 ? DayPage() : WeekPage(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_view_day), title: Text('День')),
          BottomNavigationBarItem(
              icon: Icon(Icons.view_column), title: Text('Неделя')),
        ],
      ),
    );
  }
}
