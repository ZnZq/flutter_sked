import 'package:flutter/material.dart';

class SectionTile extends StatelessWidget {
  final List<Widget> childs;
  final Function onTap;
  SectionTile({this.childs, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.only(left: 2, right: 2),
      title: Container(
        child: Column(
          children: childs,
        ),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 1,
              spreadRadius: 1,
            )
          ],
        ),
      ),
    );
  }
}
