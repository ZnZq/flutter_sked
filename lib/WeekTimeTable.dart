import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sked/TimeTableTile.dart';

import 'api/e-rozklad_api.dart';

class WeekTimeTable extends StatelessWidget {
  final weekDays = const [
    "Понедельник",
    "Вторник",
    "Среда",
    "Черверг",
    "Пятница",
    "Субота",
    "Воскресенье",
  ];

  final DateTime startDate;
  WeekTimeTable(this.startDate);

  @override
  Widget build(BuildContext context) {
    var childs = <Widget>[];

    for (int i = 0; i < weekDays.length; i++) {
      childs.add(TimeTableTile(
        title:
            '${weekDays[i]} - ${formatDate(startDate.add(Duration(days: i)), [
          dd,
          '.',
          mm
        ])}',
        lessons:
            ERozkladAPI.cache[startDate.add(Duration(days: i))] ?? [],
      ));
      childs.add(SizedBox(height: 10));
    }

    return ListView(
      children: childs,
    );
  }
}