import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_sked/WeekPage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

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
          contentPadding: EdgeInsets.all(0),
          title: Text(
            'Flutter - Sked',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20,
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
                case 2:
                  {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlutterLogo(size: 36),
                              Text(' Flutter - Sked',
                                  style: TextStyle(fontSize: 24))
                            ],
                          ),
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                        text: 'Разработчик\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(text: 'Назаренко Олексій\n\n'),
                                    TextSpan(
                                        text: 'Используется рукописное API\n'),
                                    TextSpan(text: 'для '),
                                    LinkTextSpan('e-rozklad.dut.edu.ua',
                                        'http://e-rozklad.dut.edu.ua'),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(FontAwesome.github),
                                  iconSize: 36,
                                  onPressed: () => LinkTextSpan.openLink(
                                      'https://github.com/ZnZq'),
                                ),
                                IconButton(
                                  icon: Icon(FontAwesome.telegram),
                                  iconSize: 30,
                                  onPressed: () => LinkTextSpan.openLink(
                                      'https://t.me/xZnZx'),
                                ),
                              ],
                            )
                          ],
                        );
                      },
                    );
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

class LinkTextSpan extends TextSpan {
  static openLink(String url) {
    canLaunch(url).then((value) {
      if (value) {
        launch(url, forceSafariVC: false);
      } else {
        Fluttertoast.showToast(msg: 'Не удалось открыть ссылку');
      }
    });
  }

  LinkTextSpan(String text, String url)
      : super(
            style: const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.w600),
            text: text ?? url,
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  Fluttertoast.showToast(msg: 'Не удалось открыть ссылку');
                }
              });
}
