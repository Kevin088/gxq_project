import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sharesdk_plugin/sharesdk_interface.dart';
import 'package:sharesdk_plugin/sharesdk_register.dart';
import 'app.dart';
import 'package:flutter/rendering.dart';
import 'package:rammus/rammus.dart' as rammus;
void main() {
  runApp(MainPage());
  //debugPaintLayerBordersEnabled = true;

  ShareSDKRegister register = ShareSDKRegister();

  register.setupWechat("wx9af9b57fa99042f5","f89725582f66ed27ae17239f0de57431","http://www.iqihang.com.cn/");

  register.setupSinaWeibo("470701973","f0515c6d0a56ccb1f0c77d5e2a38be4d","https://www.pgyer.com/L9wr");

  register.setupQQ("1110255218", "KEVOjmNgXbMTaEfu");

  SharesdkPlugin.regist(register);
  if(Platform.isAndroid){
    SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }



}

initPush() async {
//  var channels = List<rammus.NotificationChannel>();
//  channels.add(rammus.NotificationChannel(
//    "1",
//    "rammus",
//    "rammus test",
//    importance: rammus.AndroidNotificationImportance.MAX,
//  ));
//  //推送通知的处理 (注意，这里的id:针对Android8.0以上的设备来设置通知通道,客户端的id跟阿里云的通知通道要一致，否则收不到通知)
//  rammus.setupNotificationManager(channels);
  rammus.setupNotificationManager(id: "1",name: "rammus",description: "rammus test",);

  rammus.onNotification.listen((data){
    print("=====================onNotification"+data.toString());
  });
  rammus.onNotificationOpened.listen((data){//这里是点击通知栏回调的方法

    print("=====================onNotificationOpened"+data.toString());
  });



}





