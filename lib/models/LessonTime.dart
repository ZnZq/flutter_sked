import 'package:hive/hive.dart';

part 'LessonTime.g.dart';

@HiveType()
class LessonTime {
  @HiveField(0)
  DateTime start;

  @HiveField(1)
  DateTime end;
  LessonTime({this.start, this.end});
  @override
  String toString() {
    return '$start - $end';
  }
}