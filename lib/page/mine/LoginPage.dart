import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gxq_project/res/Colors.dart';
import 'package:gxq_project/utils/Toast.dart';
import 'package:gxq_project/utils/Utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharesdk_plugin/sharesdk_defines.dart';
import 'dart:async';

import 'package:sharesdk_plugin/sharesdk_interface.dart';

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginPageState();
  }

}

class LoginPageState extends State<LoginPage>{
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
                "QQ登录",
                style: TextStyle(
                    fontSize: 14,
                    color: MyColors.color_888888
                ),
              ),
              onPressed: (){
                SharesdkPlugin.getUserInfo(
                    ShareSDKPlatforms.qq, (SSDKResponseState state,
                    Map user, SSDKError error) {
                  Toast.toast(context,msg: user.toString());
                  print(user.toString());
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

}