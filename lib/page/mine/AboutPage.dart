import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gxq_project/res/Colors.dart';
import 'package:gxq_project/utils/Utils.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

class AboutPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProtocolPageState();
  }

}

class ProtocolPageState extends State<AboutPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        crossAxisAlignment : CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(20, 30, 0, 0),
            child: GestureDetector(
              child: Image.asset(Utils.getImgPath2("ic_back")),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ),

          Container(
            margin: EdgeInsets.fromLTRB(20, 50, 20, 0),

            child:Image.asset(Utils.getImgPath2("ic_about"))
          ),

        Container(
          margin: EdgeInsets.fromLTRB(20, 50, 20, 0),

          child:Text(
            "家庭温度自检检测计",
            style: TextStyle(color: MyColors.color_444444,fontSize: 22),
          )
        ),

        ],
      ),
    );
  }

}