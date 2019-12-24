import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'TimeTableTile.dart';
import 'WeekTimeTable.dart';
import 'e-rozklad_api.dart';

class WeekPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var week = DateTime.now().weekday;
    var now = DateTime.now();
    DateTime start =
        DateTime(now.year, now.month, now.day).add(Duration(days: 1 - week));

    var tabs = <Widget>[];
    DateTime s = start.add(Duration(days: 0));
    for (int i = 0; i < 4; i++) {
      tabs.add(Tab(
        text: '${formatDate(s, [
          dd,
          '.',
          mm
        ])} - ${formatDate(s = s.add(Duration(days: 6)), [dd, '.', mm])}',
      ));
      s = s.add(Duration(days: 1));
    }

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TabBar(
                isScrollable: true,
                tabs: tabs,
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
              for (int i = 0; i < tabs.length; i++) {
                childs.add(Center(
                  child: SpinKitCircle(
                    color: Colors.blue,
                  ),
                ));
                ERozkladAPI.update(false);
              }
            } else {
              s = start.add(Duration(days: 0));
              for (int i = 0; i < tabs.length; i++) {
                childs.add(WeekTimeTable(s));
                s = s.add(Duration(days: 7));
              }
            }

            return TabBarView(
              children: childs,
            );
          },
        ),
      ),
    );
  }
}
