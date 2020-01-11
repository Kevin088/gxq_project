import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'app.dart';
import 'package:flutter/rendering.dart';
void main() {
  runApp(MainPage());
  //debugPaintLayerBordersEnabled = true;

  if(Platform.isAndroid){
    SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}







