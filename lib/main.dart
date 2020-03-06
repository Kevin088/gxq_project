import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
//import 'package:sharesdk_plugin/sharesdk_interface.dart';
//import 'package:sharesdk_plugin/sharesdk_register.dart';
import 'app.dart';
import 'package:flutter/rendering.dart';
void main() {
  runApp(MainPage());
  //debugPaintLayerBordersEnabled = true;

  //ShareSDKRegister register = ShareSDKRegister();

//  register.setupWechat("wx9af9b57fa99042f5","f89725582f66ed27ae17239f0de57431","http://www.iqihang.com.cn/");
//
//  register.setupSinaWeibo("1044815840","c150477094bc8c045b87826b89ff9c07","http://mobile.iqihang.com");
//
//  register.setupQQ("1110255218", "KEVOjmNgXbMTaEfu");

  //SharesdkPlugin.regist(register);
  if(Platform.isAndroid){
    SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}







