import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gxq_project/page/mine/MediaPlayerPage.dart';
import 'package:gxq_project/res/Colors.dart';
import 'package:gxq_project/utils/Utils.dart';
import 'package:gxq_project/widget/CustomRoute.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

class CommonQuestionPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CommonQuestionPageState();
  }

}

class CommonQuestionPageState extends State<CommonQuestionPage>{
  File _image;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        crossAxisAlignment : CrossAxisAlignment.start,
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
            margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
            child: Text(
              "常见问题",
              style: TextStyle(
                  fontSize: 28,
                  color: Color.fromARGB(255, 0, 0, 0)
              ),
            ),
          ),
          Container(
            height: 10,
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            color: Color.fromARGB(255, 238, 238, 238),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 50, 20, 0),
            height: 177,
            decoration: new BoxDecoration(
              border: new Border.all(width: 1.0, color: MyColors.color_divider),
              color: Colors.white,
              borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
            ),
            child: Stack(
              children: <Widget>[
                  Image.asset(Utils.getImgPath2("ic_image_1")),
                  Positioned(
                    top: 43,
                    left: 60,
                    child: Text("如何连接设备频？",style: TextStyle(color: Colors.white,fontSize: 28),),
                  ),
                  Positioned(
                    top: 140,
                    right: 20,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, CustomRoute(MediaPlayerPage()));
                      },
                      child: Row(
                        children: <Widget>[
                          Text("查看详情",style: TextStyle(color: MyColors.color_444444,fontSize: 12),),
                          Image.asset(Utils.getImgPath2("ic_arraw"))
                        ],
                      ),
                    )
                  )
           
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            height: 177,
            decoration: new BoxDecoration(
              border: new Border.all(width: 1.0, color: MyColors.color_divider),
              color: Colors.white,
              borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
            ),
            child: Stack(
              children: <Widget>[
                Image.asset(Utils.getImgPath2("ic_image_2")),
                Positioned(
                  top: 33,
                  left: 40,
                  child: Text("检测体温需要注意\n的问题？",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 28,),),
                ),
                Positioned(
                    top: 140,
                    right: 20,
                    child: GestureDetector(
                      onTap: (){

                      },
                      child: Row(
                        children: <Widget>[
                          Text("查看详情",style: TextStyle(color: MyColors.color_444444,fontSize: 12),),
                          Image.asset(Utils.getImgPath2("ic_arraw"))
                        ],
                      ),
                    )
                )

              ],
            ),
          ),



        ],
      ),
    );
  }

}