import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gxq_project/utils/Utils.dart';

class MineInfoPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MineInfoPageState();
  }

}

class MineInfoPageState extends State<MineInfoPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
            child: GestureDetector(
              child: Image.asset(Utils.getImgPath2("ic_back")),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ),

        ],
      ),
    );
  }

}