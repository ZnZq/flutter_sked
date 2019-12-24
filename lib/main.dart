import 'package:flutter/material.dart';
import 'package:flutter_sked/e-rozklad_api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SkedApp.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter - Sked',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        initialData: null,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            ERozkladAPI.storage = snapshot.data;
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
