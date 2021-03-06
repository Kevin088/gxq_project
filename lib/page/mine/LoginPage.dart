import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gxq_project/bean/q_q_login_bean.dart';
import 'package:gxq_project/bean/request_login_bean.dart';
import 'package:gxq_project/bean/LoginInfoEvent.dart';
import 'package:gxq_project/bean/webo_login_bean.dart';
import 'package:gxq_project/common/api.dart';
import 'package:gxq_project/common/param_name.dart';
import 'package:gxq_project/http/httpUtil.dart';
import 'package:gxq_project/res/Colors.dart';
import 'package:gxq_project/utils/Utils.dart';
import 'package:gxq_project/utils/event_bus.dart';
import 'package:gxq_project/utils/Toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharesdk_plugin/sharesdk_defines.dart';

import 'package:sharesdk_plugin/sharesdk_interface.dart';
import 'package:rammus/rammus.dart' as rammus;
class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginPageState();
  }
  // 123 微信 qq 微博
}

class LoginPageState extends State<LoginPage>{
  String deviceId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }
  Future<void> initData() async {
//    final prefs = await SharedPreferences.getInstance();
//    deviceId=prefs.getString(ParamName.DEVICE_ID);
//    if(deviceId==null){
      deviceId= await rammus.deviceId;
//    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        crossAxisAlignment : CrossAxisAlignment.center,
        children: <Widget>[

          Container(
            height: 311,
            width: MediaQuery.of(context).size.width,
            child:Stack(
              children: <Widget>[
                Image.asset(Utils.getImgPath2("ic_login_bg"),
                  width: MediaQuery.of(context).size.width,
                  height: 311,
                  fit: BoxFit.fill,
                ),
                Positioned(
                  top: 30,
                  left: 20,
                  child: GestureDetector(
                    child: Image.asset(Utils.getImgPath2("ic_back")),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20,),
          SizedBox(
            width:  MediaQuery.of(context).size.width-40,
            height: 50,
            child:  FlatButton(
              child: Text(
                "微信登录",
                style: TextStyle(
                    fontSize: 14,
                    color: MyColors.color_888888
                ),
              ),
              onPressed: (){
               // Toast.toast(context,msg:"微信");
//                SharesdkPlugin.isClientInstalled(ShareSDKPlatforms.wechatSession)
//                .then((value){
//                  if(value){
//                    SharesdkPlugin.getUserInfo(
//                        ShareSDKPlatforms.wechatSession, (SSDKResponseState state,
//                        Map user, SSDKError error) {
//
//                      //Toast.toast(context,msg: user.toString());
//                    });
//                  }else{
//                    Toast.toast(context,msg: "请安装微信客户端");
//                  }
//                });
                SharesdkPlugin.getUserInfo(
                    ShareSDKPlatforms.wechatSession, (SSDKResponseState state,
                    Map user, SSDKError error) {

                  //Toast.toast(context,msg: user.toString());
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(28)),
                side: BorderSide(
                  color: MyColors.color_dddddd,
                  width: 1,
                ),
              ),
            ),
          ),
          SizedBox(height: 16,),
          SizedBox(
            width:  MediaQuery.of(context).size.width-40,
            height: 50,
            child:  FlatButton(
              child: Text(
                "微博登录",
                style: TextStyle(
                    fontSize: 14,
                    color: MyColors.color_888888
                ),
              ),
              onPressed: (){

                SharesdkPlugin.getUserInfo(
                    ShareSDKPlatforms.sina, (SSDKResponseState state,
                    Map user, SSDKError error) {

                  if(user!=null){
                    Map<String,dynamic> temp=new Map<String,dynamic>.from(user);
                    var dbInfo=temp["dbInfo"];
                    Map<String,dynamic>map=json.decode(dbInfo.toString());
                    WeboLoginBean bean=WeboLoginBean.fromJson(map);

                    if(bean!=null){
                      RequestLoginBean loginBean=new RequestLoginBean();
                      loginBean.avatar=bean?.icon;
                      loginBean.openId=bean?.userID;
                      loginBean.nickName=bean?.nickname;
                      loginBean.loginType=2;
                      loginBean.device=deviceId;
                      login(loginBean);
                    }
                  }
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(28)),
                side: BorderSide(
                  color: MyColors.color_dddddd,
                  width: 1,
                ),
              ),
            ),
          ),
          SizedBox(height: 16,),
          SizedBox(
            width:  MediaQuery.of(context).size.width-40,
            height: 50,
            child:  FlatButton(
              child: Text(
                "QQ登录",
                style: TextStyle(
                    fontSize: 14,
                    color: MyColors.color_888888
                ),
              ),
              onPressed: (){
                SharesdkPlugin.getUserInfo(
                    ShareSDKPlatforms.qq, (SSDKResponseState state,
                    Map user, SSDKError error) async {
                  if(user!=null){
                    Map<String,dynamic> temp=new Map<String,dynamic>.from(user);
                    var dbInfo=temp["dbInfo"];
                    Map<String,dynamic>map=json.decode(dbInfo.toString());
                    QQLoginBean bean=QQLoginBean.fromJson(map);
                    if(bean!=null){
                      RequestLoginBean loginBean=new RequestLoginBean();
                      loginBean.avatar=bean?.icon;
                      loginBean.openId=bean?.userID;
                      loginBean.nickName=bean?.nickname;
                      loginBean.loginType=2;
                      loginBean.device=deviceId;
                      login(loginBean);
                    }
                  }
                });

//                SharesdkPlugin.isClientInstalled(ShareSDKPlatforms.qq)
//                    .then((value){
//                  if(value){
//
//                  }else{
//                    Toast.toast(context,msg: "请安装qq客户端");
//                  }
//                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(28)),
                side: BorderSide(
                  color: MyColors.color_dddddd,
                  width: 1,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Future<void> login(RequestLoginBean data) async {
    var param={
      "avatar":data.avatar,
      "device":data.device,
      "gender":data.gender,
      "loginType":data.loginType,
      "nickName":data.nickName,
      "openId":data.openId,
    };
    Response response=await HttpUtil.getInstance().post(Api.LOGIN,data: param);
    if (!mounted) return;
    var loginInfo=response?.data;
    var dataInfo=loginInfo['data'];
    int userId=dataInfo['id'];
    String avatar=dataInfo['avatar'];
    String nickName=dataInfo['nickName'];
    String token=dataInfo['token'];
    HttpUtil.getInstance().setToken(token);
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    prefs.setInt(ParamName.SP_USER_ID, userId);
    prefs.setString(ParamName.SP_USER_AVATOR, avatar);
    prefs.setString(ParamName.SP_USER_NAME, nickName);
    prefs.setString(ParamName.SP_USER_TOKEN, token);
    prefs.setBool(ParamName.IS_LOGIN, true);


    LoginInfoEvent loginInfoEvent=new LoginInfoEvent();
    loginInfoEvent.userId=userId;
    loginInfoEvent.avatar=avatar;
    loginInfoEvent.nickName=nickName;
    loginInfoEvent.token=token;

    eventBus.fire(loginInfoEvent);

    Navigator.pop(context);
  }
}