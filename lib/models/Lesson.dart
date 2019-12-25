import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'LessonTime.dart';
import 'LessonType.dart';
import 'Name.dart';

part 'Lesson.g.dart';

@HiveType()
class Lesson {
  @HiveField(0)
  int number;
  @HiveField(1)
  LessonTime time;
  @HiveField(2)
  LessonType type = LessonType.window;
  @HiveField(3)
  Name name = Name(fullName: '', shortName: '');
  @HiveField(4)
  String groupName = '';
  @HiveField(5)
  String hall = '';
  @HiveField(6)
  Name teacher = Name(fullName: '', shortName: '');
  @HiveField(7)
  String info = '';
  @HiveField(8)
  DateTime date = DateTime.now();

  Lesson(
      {@required this.number,
      @required this.time,
      this.type,
      this.groupName,
      this.hall,
      this.info,
      this.name,
      this.teacher, 
      this.date});

  Lesson.window({this.number, this.time});

  @override
  String toString() {
    return '${time.start} ${name.shortName}';
  }
}
