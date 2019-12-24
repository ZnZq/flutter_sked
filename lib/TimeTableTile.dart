import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sked/SectionTile.dart';
import 'package:flutter_sked/e-rozklad_api.dart';

import 'LessonTile.dart';

class TimeTableTile extends StatelessWidget {
  String title;
  List<Lesson> lessons;

  TimeTableTile({this.title, this.lessons = const []});

  @override
  Widget build(BuildContext context) {
    var childs = <Widget>[
      for (int i = 0; i < lessons.length; i++) LessonTile(lessons[i])
    ];
    if (lessons.length == 0)
      childs.add(SectionTile([
        Center(
          child: Text('Пар нет', style: TextStyle(fontSize: 16, height: 1.5)),
        )
      ]));
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          if (title != null)
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ...childs
        ],
      ),
    );
  }
}
