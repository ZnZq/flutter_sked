import 'package:flutter/material.dart';
import 'package:flutter_sked/SkedApp.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';

import 'SkedAppLogin.dart';
import 'api/e-rozklad_api.dart';

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter - Sked',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: Hive.openBox('cache'),
        initialData: null,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            ERozkladAPI.init();
            return ERozkladAPI.group == '' ? SkedAppLogin() : SkedApp();
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
    );
  }
}
