import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sked/e-rozklad_api.dart';

import 'LessonTile.dart';

class TimeTableTile extends StatelessWidget {
  DateTime date;
  List<Lesson> lessons;

  TimeTableTile({this.date, this.lessons = const []});

  @override
  Widget build(BuildContext context) {
    var childs = <Widget>[for (int i = 0; i < lessons.length; i++) LessonTile(lessons[i])];
    if (lessons.length == 0)
      childs.add(Text('Пар нет'));
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          if (date != null)
            Text(
              formatDate(date, [dd, '.', mm]),
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ...childs
        ],
      ),
    );
  }
}
