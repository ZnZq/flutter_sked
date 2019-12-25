import 'package:flutter/material.dart';
import 'package:flutter_sked/WeekPage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';

import 'DayPage.dart';
import 'SkedAppLogin.dart';
import 'api/e-rozklad_api.dart';

class SkedApp extends StatefulWidget {
  @override
  createState() => SkedAppState();
}

class SkedAppState extends State<SkedApp> {
  int _selectedIndex = 0;
  bool _isRefresh = false;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          subtitle: Text(ERozkladAPI.groupName,
              style: TextStyle(color: Colors.white70)),
        ),
        actions: <Widget>[
          if (_isRefresh)
            IconButton(
              icon: SpinKitCircle(
                color: Colors.white,
                size: 24,
              ),
              tooltip: 'Обновить расписание',
              onPressed: () {},
            )
          else
            IconButton(
              icon: Icon(Icons.loop),
              tooltip: 'Обновить расписание',
              onPressed: () async {
                ERozkladAPI.update().then((q) {
                  setState(() => _isRefresh = false);
                });
                setState(() => _isRefresh = true);
              },
            ),
          PopupMenuButton<int>(
            icon: Icon(Icons.more_vert),
            onSelected: (select) {
              switch (select) {
                case 1:
                  {
                    var box = Hive.box('cache');
                    box.put('group', ERozkladAPI.group = '');
                    box.put('groupName', ERozkladAPI.groupName = '');
                    box.put('cache', ERozkladAPI.cache..clear());
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SkedAppLogin()),
                        ModalRoute.withName('/'));
                    break;
                  }
              }
            },
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
