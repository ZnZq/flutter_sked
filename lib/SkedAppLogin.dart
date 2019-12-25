import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';

import 'SkedApp.dart';
import 'api/e-rozklad_api.dart';

class SkedAppLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SkedAppLoginState();
}

class SkedAppLoginState extends State<SkedAppLogin> {
  final _formKey = GlobalKey<FormState>();

  String _faculty = '', _course = '', _group = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Flutter - Sked Login'),
          automaticallyImplyLeading: false),
      body: StreamBuilder(
        stream: ERozkladAPI.groupDataStream,
        initialData: null,
        builder: (context, snapshot) {
          var childs = <Widget>[];
          if (snapshot.data == null) {
            childs.add(Center(child: SpinKitCircle(color: Colors.blue)));
            if (_faculty.isEmpty) ERozkladAPI.getOptions();
          } else {
            var data = snapshot.data as Map<String, Map<String, String>>;

            childs.add(Text('Факультет'));
            childs.add(DropdownButton<String>(
              isExpanded: true,
              value: _faculty,
              items: data['faculty']
                  .entries
                  .map((kv) => DropdownMenuItem<String>(
                        value: kv.key,
                        child: Text(kv.value),
                      ))
                  .toList(),
              onChanged: (String value) {
                ERozkladAPI.getOptions(faculty: value);
                setState(() {
                  _faculty = value;
                  _course = '';
                  _group = '';
                });
              },
            ));

            if (data['course'].length > 1) {
              childs.add(Text('Курс'));
              childs.add(DropdownButton<String>(
                isExpanded: true,
                value: _course,
                items: data['course']
                    .entries
                    .map((kv) => DropdownMenuItem<String>(
                          value: kv.key,
                          child: Text(kv.value),
                        ))
                    .toList(),
                onChanged: (String value) {
                  ERozkladAPI.getOptions(faculty: _faculty, course: value);
                  setState(() {
                    _course = value;
                    _group = '';
                  });
                },
              ));
            }

            if (data['group'].length > 1) {
              childs.add(Text('Группа'));
              childs.add(DropdownButton<String>(
                isExpanded: true,
                value: _group,
                items: data['group']
                    .entries
                    .map((kv) => DropdownMenuItem<String>(
                          value: kv.key,
                          child: Text(kv.value),
                        ))
                    .toList(),
                onChanged: (String value) {
                  setState(() => _group = value);
                },
              ));
            }

            if (_group.isNotEmpty) {
              childs.add(FlatButton(
                child: Text('Сохранить'),
                onPressed: () {
                  var box = Hive.box('cache');
                  box.put('group', ERozkladAPI.group = _group);
                  box.put('groupName',
                      ERozkladAPI.groupName = data['group'][_group]);
                  box.put('cache', ERozkladAPI.cache..clear());
                  _faculty = _course = _group = '';

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SkedApp()),
                      ModalRoute.withName('/'));
                },
              ));
            }
          }

          return Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: childs,
            ),
          );
        },
      ),
    );
  }
}
