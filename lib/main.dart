import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'app.dart';

void main() {
  runApp(MainPage());
  if(Platform.isAndroid){
    SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}







