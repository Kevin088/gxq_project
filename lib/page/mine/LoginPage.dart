import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gxq_project/bean/q_q_login_bean.dart';
import 'package:gxq_project/bean/request_login_bean.dart';
import 'package:gxq_project/bean/webo_login_bean.dart';
import 'package:gxq_project/common/api.dart';
import 'package:gxq_project/common/param_name.dart';
import 'package:gxq_project/http/httpUtil.dart';
import 'package:gxq_project/res/Colors.dart';
import 'package:gxq_project/utils/Toast.dart';
import 'package:gxq_project/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharesdk_plugin/sharesdk_defines.dart';

import 'package:sharesdk_plugin/sharesdk_interface.dart';

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
    final prefs = await SharedPreferences.getInstance();
    deviceId=prefs.getString(ParamName.DEVICE_ID);
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
                Toast.toast(context,msg:"微信");

                SharesdkPlugin.getUserInfo(
                    ShareSDKPlatforms.wechatSession, (SSDKResponseState state,
                    Map user, SSDKError error) {
                  Toast.toast(context,msg: user.toString());
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
    print(response?.data.toString());
  }
}