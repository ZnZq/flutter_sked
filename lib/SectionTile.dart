import 'package:flutter/material.dart';

class SectionTile extends StatelessWidget {
  final List<Widget> childs;
  SectionTile(this.childs);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Column(
        children: childs,
      ),
      width: MediaQuery.of(context).size.width - 3,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 2,
            spreadRadius: 1,
          )
        ],
      ),
    );
  }
}
