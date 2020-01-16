import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gxq_project/res/Colors.dart';
import 'package:gxq_project/utils/Utils.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

class FeedbackPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FeedbackPageState();
  }

}

class FeedbackPageState extends State<FeedbackPage>{
  @override
  Widget build(BuildContext context) {

    final controller = TextEditingController();
    controller.addListener(() {
      print('input ${controller.text}');
    });
    // TODO: implement build
    return Scaffold(
      body: Column(
        crossAxisAlignment : CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(20, 30, 0, 0),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  child: Image.asset(Utils.getImgPath2("ic_back")),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
            child: Row(
              children: <Widget>[
                Text(
                  "意见反馈",
                  style: TextStyle(
                      fontSize: 28,
                      color: Color.fromARGB(255, 0, 0, 0)
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 10,
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            color: Color.fromARGB(255, 238, 238, 238),
          ),
          buildTextField(controller),


        ],
      ),
    );
  }

  Widget buildTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      maxLength: 140,//最大长度，设置此项会让TextField右下角有一个输入数量的统计字符串
      autocorrect: true,//是否自动更正
      autofocus: true,//是否自动对焦

      textAlign: TextAlign.left,//文本对齐方式
      style: TextStyle(fontSize: 30.0, color: Colors.blue),//输入文本的样式
      onChanged: (text) {//内容改变的回调
        print('change $text');
      },
      onSubmitted: (text) {//内容提交(按回车)的回调
        print('submit $text');
      },
    );
  }

}