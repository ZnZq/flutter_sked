import 'package:flutter/material.dart';
import 'package:flutter_sked/SectionTile.dart';

import 'LessonTile.dart';
import 'models/Lesson.dart';

class TimeTableTile extends StatefulWidget {
  final String title;
  final List<Lesson> lessons;

  TimeTableTile({this.title, this.lessons = const []});

  @override
  _TimeTableTileState createState() => _TimeTableTileState();
}

class _TimeTableTileState extends State<TimeTableTile> {
  @override
  Widget build(BuildContext context) {
    var childs = <Widget>[
      for (int i = 0; i < widget.lessons.length; i++) LessonTile(widget.lessons[i])
    ];
    if (widget.lessons.length == 0)
      childs.add(SectionTile([
        Center(
          child: Text('Пар нет', style: TextStyle(fontSize: 16, height: 1.5)),
        )
      ]));
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          if (widget.title != null)
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ...childs
        ],
      ),
    );
  }
}
