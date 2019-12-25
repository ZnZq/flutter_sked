import 'package:hive/hive.dart';

part 'LessonType.g.dart';

@HiveType()
enum LessonType { 
  @HiveField(0)
  lecture, 
  @HiveField(1)
  laboratory, 
  @HiveField(2)
  practical, 
  @HiveField(3)
  offset, 
  @HiveField(4)
  exam, 
  @HiveField(5)
  window 
}