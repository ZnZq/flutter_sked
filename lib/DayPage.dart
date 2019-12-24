import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sked/e-rozklad_api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'TimeTableTile.dart';

class DayPage extends StatefulWidget {
  @override
  _DayPageState createState() => _DayPageState();
}

class _DayPageState extends State<DayPage> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var week = DateTime.now().weekday;
    var now = DateTime.now();
    DateTime start =
        DateTime(now.year, now.month, now.day).add(Duration(days: 1 - week));

    _tabController =
        TabController(length: 7, vsync: this, initialIndex: week - 1);

    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: [
                  Tab(text: 'Понедельник'),
                  Tab(text: 'Вторник'),
                  Tab(text: 'Среда'),
                  Tab(text: 'Четверг'),
                  Tab(text: 'Пятница'),
                  Tab(text: 'Субота'),
                  Tab(text: 'Воскресенье'),
                ],
              )
            ],
          ),
        ),
        body: StreamBuilder(
          stream: ERozkladAPI.rozkladStream,
          initialData: ERozkladAPI.getInitialData(start),
          builder: (context, snapshot) {
            var childs = <Widget>[];
            if (snapshot.data == null) {
              for (int i = 0; i < 7; i++) {
                childs.add(Center(
                  child: SpinKitCircle(
                    color: Colors.blue,
                  ),
                ));
                ERozkladAPI.update(false);
              }
            } else {
              for (int i = 0; i < 7; i++)
                childs.add(TimeTableTile(
                  title:
                      formatDate(start.add(Duration(days: i)), [dd, '.', mm]),
                  lessons:
                      ERozkladAPI.cache[start.add(Duration(days: i))] ?? [],
                ));
            }

            return TabBarView(
              controller: _tabController,
              children: childs,
            );
          },
        ),
      ),
    );
  }
}
