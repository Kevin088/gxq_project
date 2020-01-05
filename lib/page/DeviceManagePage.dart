import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gxq_project/utils/Toast.dart';
import 'package:gxq_project/utils/Utils.dart';
import 'package:gxq_project/widget/SlideButton.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

class DeviceManagePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DeviceManageState();
  }

}

class DeviceManageState extends State<DeviceManagePage>{
  List<SlideButton> list;
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
              "设备管理",
              style: TextStyle(
                  fontSize: 28,
                  color: Color.fromARGB(255, 0, 0, 0)
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: getSlides(),
            ),
          )

        ],
      ),
    );
  }



  List<SlideButton> getSlides() {
    list = List<SlideButton>();
    for (var i = 0; i < 5; i++) {
      var key = GlobalKey<SlideButtonState>();
      var slide = SlideButton(
        key: key,
        singleButtonWidth: 80,
        onSlideStarted: (){
          list.forEach((slide){
            if(slide.key!=key){
              slide.key.currentState?.close();
            }
          });
        },
        child: Container(
          color: Colors.white,
          child: ListTile(
            title: Text("测试测试测试测试测试测试测试测试"),
          ),
        ),
        //滑动开显示的button
        buttons: <Widget>[
          buildAction(key, "置顶", Colors.grey[400], () {
            Toast.toast(context,msg:"置顶");
            key.currentState.close();
          }),
          buildAction(key, "标为未读", Colors.amber, () {
            Toast.toast(context,msg:"标为未读");
            key.currentState.close();
          }),
          buildAction(key, "删除", Colors.red, () {
            Toast.toast(context,msg:"删除");
            key.currentState.close();
          }),
        ],
      );
      list.add(slide);
    }
    return list;
  }

  //构建button
  InkWell buildAction(GlobalKey<SlideButtonState> key, String text, Color color,
      GestureTapCallback tap) {

    return InkWell(
      onTap: tap,
      child: Container(
        alignment: Alignment.center,
        width: 80,
        color: color,
        child: Text(text,
            style: TextStyle(
              color: Colors.white,
            )),
      ),
    );
  }

}