import 'package:flutter/material.dart';
import 'package:flutter_sked/models/Lesson.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path;

import 'MainApp.dart';
import 'models/LessonTime.dart';
import 'models/LessonType.dart';
import 'models/Name.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final docsPath = await path.getApplicationDocumentsDirectory();
  Hive.init(docsPath.path);
  Hive.registerAdapter(LessonAdapter(), 0);
  Hive.registerAdapter(LessonTimeAdapter(), 1);
  Hive.registerAdapter(NameAdapter(), 2);
  Hive.registerAdapter(LessonTypeAdapter(), 3);
  runApp(MainApp());
}
