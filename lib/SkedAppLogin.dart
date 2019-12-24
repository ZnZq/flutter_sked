import 'package:flutter/material.dart';
import 'package:flutter_sked/e-rozklad_api.dart';

class SkedAppLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SkedAppLoginState();
}

class SkedAppLoginState extends State<SkedAppLogin> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Flutter - Sked Login'),
          automaticallyImplyLeading: false),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DropdownButton<String>(items: [], onChanged: (value) {},
              // items: _facults
              //     .map((id, value) {
              //       return MapEntry(
              //           value,
              //           DropdownMenuItem<String>(
              //             value: id,
              //             child: Text(value),
              //           ));
              //     })
              //     .values
              //     .toList(),
              // value: "",
              // onChanged: (newValue) {
              //   setState(() {
              //     _currentFacult = newValue;
              //   });
              // },
            )
          ],
        ),
      ),
    );
  }
}
