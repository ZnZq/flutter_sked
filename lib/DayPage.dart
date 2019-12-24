import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sked/e-rozklad_api.dart';

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

    
    _tabController = TabController(length: 5, vsync: this, initialIndex: min(week - 1, 4));

    return DefaultTabController(
      length: 5,
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
                  Tab(text: 'Пятница')
                ],
              )
            ],
          ),
        ),
        body: StreamBuilder(
          stream: ERozkladAPI.rozkladStream,
          builder: (context, snapshot) {
            return TabBarView(
              controller: _tabController,
              children: [
                for (int i = 0; i < 5; i++)
                  TimeTableTile(
                    date: start.add(Duration(days: i)),
                    lessons:
                        ERozkladAPI.cache[start.add(Duration(days: i))] ?? [],
                  )
              ],
            );
          },
        ),
      ),
    );
  }
}
