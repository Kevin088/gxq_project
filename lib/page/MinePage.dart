import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gxq_project/bean/LoginInfoEvent.dart';
import 'package:gxq_project/common/param_name.dart';
import 'package:gxq_project/page/mine/LoginPage.dart';
import 'package:gxq_project/page/mine/MediaPlayerPage.dart';
import 'package:gxq_project/utils/Toast.dart';
import 'package:gxq_project/utils/Utils.dart';
import 'package:gxq_project/utils/event_bus.dart';
import 'package:gxq_project/widget/CustomRoute.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mine/AboutPage.dart';
import 'mine/FeedbackPage.dart';
import 'mine/ProtocolPage.dart';
import 'mine/SetPage.dart';

class MinePage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MinePageState();
  }

}

class MinePageState extends State<MinePage>{
  bool isLogin=false;
  String name;
  String phone;
  String img="";

  StreamSubscription eventBusOn;
  @override
  void initState(){
    // TODO: implement initState
    super.initState();



    eventBusOn=eventBus.on<LoginInfoEvent>().listen((event){
      Toast.toast(context,msg: event.nickName);
      setState(() {
        isLogin=true;
        name=event.nickName;
        img=event.avatar;
      });
    });
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    eventBusOn.cancel();
  }


  Future<void> getData() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    isLogin= prefs.getBool(ParamName.IS_LOGIN)??false;
    name= prefs.getString(ParamName.SP_USER_NAME)??"";
    img= prefs.getString(ParamName.SP_USER_AVATOR)??"";
    setState(() {

    });
  }
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
          body: Container(
            margin:  EdgeInsets.fromLTRB(10,50,10,0),
            child: Column(
              children: <Widget>[
                Row(children: <Widget>[
//                img==""?
//                      CircleAvatar(
//                        radius: 36.0,
//                        backgroundImage: AssetImage(Utils.getImgPath2("ic_avatar"))
//
//                      ):Image.network(img,fit: BoxFit.fill),
                  new ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child:!isLogin? new Image.asset(Utils.getImgPath2('ic_avatar')):
                    Image.network(img,fit: BoxFit.fill,width: 66,height: 66,),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          isLogin?name:"",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child:
                            Text(
                              "",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Color.fromARGB(255, 178, 178, 178)
                              ),
                            )
                        ),
                      ],
                    )
                  ),
                ],)
                ,
                SizedBox(height: 30.0),
                getText("设备管理",
                    (){
                     // Navigator.push(context, CustomRoute(DeviceManagePage()));
                    }),
                Divider(height: 1.0,color: Color.fromARGB(255, 220, 220, 220)),
                getText("提醒设置", (){
                  Navigator.push(context, CustomRoute(SetPage()));
                }),
                Divider(height: 1.0,color: Color.fromARGB(255, 220, 220, 220)),
                getText("服务条款",(){
                  Navigator.push(context, CustomRoute(ProtocolPage()));
                }),
                Divider(height: 1.0,color: Color.fromARGB(255, 220, 220, 220)),
                getText("意见反馈",() async {
                  var prefs = await SharedPreferences.getInstance();
                  bool isLogin=prefs.getBool(ParamName.IS_LOGIN)??false;
                  if(!isLogin){
                    Navigator.push(context, CustomRoute(LoginPage()));
                    return;
                  }
                  Navigator.push(context, CustomRoute(FeedbackPage()));
                }),
                Divider(height: 1.0,color: Color.fromARGB(255, 220, 220, 220)),
                getText("关于我们",(){
                  Navigator.push(context, CustomRoute(AboutPage()));
                }),
                Divider(height: 1.0,color: Color.fromARGB(255, 220, 220, 220)),
                Expanded(child: Container()),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: FlatButton(
                    onPressed: () async {
                      if(!isLogin){
                        Navigator.push(context, CustomRoute(LoginPage()));
                      }else{
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        if (!mounted) return;
                        prefs.setBool(ParamName.IS_LOGIN,false);
                        isLogin=false;
                        setState(() {

                        });
                      }
                    },
                    child: Container(
                      margin:  EdgeInsets.fromLTRB(20,0,20,0),
                      height: 40,
                      alignment: const Alignment(0,0),
                      child: Text(
                          isLogin?"退出登录":"登录",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 136, 136, 136)
                        ),
                      ),
                    ),
                    color: Colors.white,

                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        side: BorderSide(
                            color: Color.fromARGB(255, 211, 211, 211),
                          width: 1,
                        ),
                    ),
                  ),
                )
              ],
            ),
          ),
      ),
    );
  }
  GestureDetector getText(String text,Function callBack){
    return GestureDetector(
      onTap: callBack,
      child: Container(
        padding: EdgeInsets.fromLTRB(10,0,10,0),
        height: 50.0,
        child: Row(

          children: <Widget>[
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            )
            ,
            Image(
              image: AssetImage(Utils.getImgPath2("ic_arraw")),
            )

          ],
        ),
      ),
    );

  }



}