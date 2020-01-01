import 'package:flutter/material.dart';
import 'package:flutter_sked/SectionTile.dart';

import 'LessonTile.dart';
import 'models/Lesson.dart';

class TimeTableTile extends StatelessWidget {
  final String title;
  final List<Lesson> lessons;

  TimeTableTile({this.title, this.lessons = const []});

  @override
  Widget build(BuildContext context) {
    var childs = <Widget>[
      if (title != null)
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      for (int i = 0; i < lessons.length; i++) LessonTile(lessons[i])
    ];
    if (lessons.length == 0)
      childs.add(SectionTile(
        childs: [
          Center(
            child: Text('Пар нет', style: TextStyle(fontSize: 16, height: 1.5)),
          )
        ],
      ));
    return Column(
      children: childs,
    );
  }
}
