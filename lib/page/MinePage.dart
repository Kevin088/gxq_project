import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gxq_project/utils/Utils.dart';

class MinePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MinePageState();
  }

}

class MinePageState extends State<MinePage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      home:Scaffold(
//        appBar: AppBar(
//          title: Text("我的"),
//          backgroundColor: Color.fromARGB(255, 199, 136, 213),
//          centerTitle: true,
//        ),
        body: Column(

          children: <Widget>[
            CircleAvatar(
              radius: 36.0,
              backgroundImage: AssetImage(Utils.getImgPath2("ali_connors")),
            ),
          ],
        ),
      ),


    );
  }

}