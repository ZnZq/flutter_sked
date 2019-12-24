import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sked/SectionTile.dart';
import 'package:flutter_sked/e-rozklad_api.dart';

class LessonTile extends StatelessWidget {
  Lesson lesson;

  LessonTile(this.lesson);

  @override
  Widget build(BuildContext context) {
    var start = lesson.time.start;
    var end = lesson.time.end;

    var style = TextStyle(fontSize: 16, height: 1.5);

    return SectionTile([
      if (lesson.type != LessonType.window)
        LeftRight([
          Text(lesson.name.fullName, style: style),
          Text(ERozkladAPI.lessonTypeToString(lesson.type), style: style),
        ])
      else
        Center(
          child:
              Text(ERozkladAPI.lessonTypeToString(lesson.type), style: style),
        ),
      LeftRight([
        Text(lesson.number.toString(), style: style),
        Text(
            '${formatDate(start, [HH, ':', nn])} - ${formatDate(end, [
              HH,
              ':',
              nn
            ])}',
            style: style),
      ]),
      if (lesson.type != LessonType.window)
        LeftRight([
          Text(lesson.teacher.fullName, style: style),
          Text(lesson.hall, style: style),
        ]),
    ]);
  }

  LeftRight(List<Widget> childs) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: childs,
    );
  }
}
