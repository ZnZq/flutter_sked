import 'package:flutter/material.dart';
import 'package:flutter_sked/api/e-rozklad_api.dart';
import 'package:flutter_sked/models/Lesson.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path;

import 'SkedApp.dart';
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
  runApp(
    MaterialApp(
      title: 'Flutter - Sked',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: Hive.openBox('cache'),
        initialData: null,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            ERozkladAPI.init();
            return SkedApp();
          } else {
            return Scaffold(
              appBar: AppBar(title: Text('Flutter - Sked')),
              body: Center(
                child: SpinKitWave(
                  color: Colors.blue,
                  size: 50.0,
                ),
              ),
            );
          }
        },
      ),
    ),
  );
}
