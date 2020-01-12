import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gxq_project/page/TemperatureSetPage.dart';
import 'package:gxq_project/res/Colors.dart';
import 'package:gxq_project/utils/Toast.dart';
import 'package:gxq_project/utils/Utils.dart';
import 'package:gxq_project/widget/CustomRoute.dart';
import 'package:gxq_project/widget/SlideButton.dart';

class DeviceManagePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DeviceManageState();
  }

}

class DeviceManageState extends State<DeviceManagePage>{
  List<SlideButton> list = List<SlideButton>();
  var currentSelect=0;
  var isEmpty=true;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child:    Row(
              children: <Widget>[
                GestureDetector(
                  child: Image.asset(Utils.getImgPath2("ic_back")),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
                Expanded(child: Container(),),
                GestureDetector(
                  child: Image.asset(Utils.getImgPath2("ic_add")),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
              ],
            )
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
          getBodyView(),

        ],
      ),
    );
  }



  SlideButton getSlides(int index) {
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
          decoration:BoxDecoration(
            border: new Border.all(width: 1.0, color: index==currentSelect?MyColors.color_00286B:MyColors.color_divider),
            borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
            color: index==currentSelect?MyColors.color_00286B:Colors.white,
          ),
          height: 92,
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                      Text(
                          "KHO温度设背景名称",
                          style: TextStyle(color: index==currentSelect?Colors.white:MyColors.color_444444,fontSize: 16),
                      ),
                    Text(
                      "未连接",
                      style: TextStyle(color: index==currentSelect?Colors.white:MyColors.color_9A9A9A,fontSize: 12),
                    ),
                  ],
                ),
                Expanded(child: Container(),),
                GestureDetector(
                  child:Image.asset(index==currentSelect?Utils.getImgPath2("ic_is_select"):Utils.getImgPath2("ic_no_select")),
                  onTap: (){
                    setState(() {
                      currentSelect=index;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        //滑动开显示的button
        buttons: <Widget>[
          buildAction2(key, "修改名称", MyColors.color_3464BA, () {
            Toast.toast(context,msg:"标为未读");
            key.currentState.close();
          }),
          buildAction1(key, "删除设备", MyColors.color_DF6565, () {
            Toast.toast(context,msg:"删除");
            key.currentState.close();
          }),
        ],
      );
      list.add(slide);
    return slide;
  }

  //构建button
  InkWell buildAction1(GlobalKey<SlideButtonState> key, String text, Color color,
      GestureTapCallback tap) {

    return InkWell(
      onTap: tap,
      child: Container(
        decoration:BoxDecoration(
          borderRadius: new BorderRadius.only(topRight: new Radius.circular(10.0),bottomRight: new Radius.circular(10.0)),
          color: color,
        ),
        alignment: Alignment.center,
        width: 80,
        height: 92,
        child: Text(text,
            style: TextStyle(
              color: Colors.white,
            )),
      ),
    );
  }
  //构建button
  InkWell buildAction2(GlobalKey<SlideButtonState> key, String text, Color color,
      GestureTapCallback tap) {

    return InkWell(
      onTap: tap,
      child: Container(
        decoration:BoxDecoration(
          color: color,
        ),
        alignment: Alignment.center,
        width: 100,
        height: 92,
        child: Text(text,
            style: TextStyle(
              color: Colors.white,
            )),
      ),
    );
  }


  Widget getBodyView(){
    if(isEmpty){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Container(height: 73,)
              ],
            ),
            color: Colors.white,
          ),
          Image.asset(Utils.getImgPath2("ic_device_manage_empty")),
          SizedBox(height: 23,),
          Text(
            "您还没有绑定过设备",
            style: TextStyle(color: MyColors.color_444444,fontSize: 20,fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16,),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            child:Text(
              "可以启动体温检测计蓝牙开关后，点击右上角+进行设备连接，"
                  "您也可以点击下方\"查看帮助\"按钮，查看连接设备帮助视频",
              style: TextStyle(color: MyColors.gray_999999,fontSize: 12),
              textAlign: TextAlign.center,
            ) ,
          ),
          SizedBox(height: 45),
          Container(
            width: 300,
            height: 45,
            child:RaisedButton(
              child: new Text("查看帮助",style: TextStyle(fontSize: 16),),
              color: MyColors.color_00286B ,
              textColor: Colors.white ,

              onPressed: (){
                Navigator.push(context, CustomRoute(TemperatureSetPage()));
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)), //圆角大小
            ),
          ),


        ],
      );
    }else{
      return Expanded(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: ListView.separated(
            itemCount: 5,
            separatorBuilder: (BuildContext context, int index) => new Divider(height: 20,color: Colors.white,),  // 添加分割线
            itemBuilder: (context, index) {
              return getSlides(index);
            },
          ),
        ),
      );
    }
  }
}