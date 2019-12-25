import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sked/SectionTile.dart';
import 'package:flutter_sked/api/e-rozklad_api.dart';

import 'models/Lesson.dart';
import 'package:flutter_sked/models/LessonType.dart';

class LessonTile extends StatelessWidget {
  final Lesson lesson;

  LessonTile(this.lesson);

  @override
  Widget build(BuildContext context) {
    var start = lesson.time.start;
    var end = lesson.time.end;

    var style = TextStyle(fontSize: 16, height: 1.5);

    return SectionTile(
      onTap: lesson.type != LessonType.window
          ? () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: Center(child: Text('Информация')),
                      contentPadding:
                          EdgeInsets.all(10),
                      children: <Widget>[
                        Center(
                            child: Text('Название',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))),
                        Text(
                            '${lesson.name.fullName}\n(${lesson.name.shortName})',
                            textAlign: TextAlign.center),
                            SizedBox(height: 10),
                        Center(
                            child: Text('Тип',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))),
                        Text(ERozkladAPI.lessonTypeToString(lesson.type),
                            textAlign: TextAlign.center),
                            SizedBox(height: 10),
                        Center(
                            child: Text('Номер пары',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))),
                        Text('${lesson.number}', textAlign: TextAlign.center),
                        SizedBox(height: 10),
                        Center(
                            child: Text('Аудитория',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))),
                        Text(lesson.hall, textAlign: TextAlign.center),
                        SizedBox(height: 10),
                        Center(
                            child: Text('Преподователь',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))),
                        Text(lesson.teacher.fullName,
                            textAlign: TextAlign.center),
                            SizedBox(height: 10),
                        Center(
                            child: Text('Время',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))),
                        Text(
                            '${formatDate(start, [
                              HH,
                              ':',
                              nn
                            ])} - ${formatDate(end, [HH, ':', nn])}',
                            textAlign: TextAlign.center),
                            SizedBox(height: 10),
                        Center(
                            child: Text('Дата',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))),
                        Text(
                            formatDate(
                                lesson.date, [dd, '.', mm, '.', yyyy]),
                            textAlign: TextAlign.center),
                            SizedBox(height: 10),
                        Center(
                            child: Text('Информация',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))),
                        Text(lesson.info, textAlign: TextAlign.center),
                      ],
                    );
                  });
            }
          : null,
      childs: [
        if (lesson.type != LessonType.window)
          leftRight([
            Text(lesson.name.fullName, style: style),
            Text(ERozkladAPI.lessonTypeToString(lesson.type), style: style),
          ])
        else
          Center(
            child:
                Text(ERozkladAPI.lessonTypeToString(lesson.type), style: style),
          ),
        leftRight([
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
          leftRight([
            Text(lesson.teacher.fullName, style: style),
            Text(lesson.hall, style: style),
          ]),
      ],
    );
  }

  Widget leftRight(List<Widget> childs) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: childs,
    );
  }
}
