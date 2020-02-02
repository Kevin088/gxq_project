import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sharesdk_plugin/sharesdk_interface.dart';
import 'package:sharesdk_plugin/sharesdk_register.dart';
import 'app.dart';
import 'package:flutter/rendering.dart';
void main() {
  runApp(MainPage());
  //debugPaintLayerBordersEnabled = true;

  ShareSDKRegister register = ShareSDKRegister();

  register.setupWechat("wx9af9b57fa99042f5","f89725582f66ed27ae17239f0de57431","http://www.iqihang.com.cn/");

  register.setupSinaWeibo("2682983957","94c87e1eab2f5d158aeceb2f707927d2","http://www.iqihang.com.cn/");

  register.setupQQ("101375266", "6466068c5e088ee00ba7a9a48d65142b");

  SharesdkPlugin.regist(register);
  if(Platform.isAndroid){
    SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}







