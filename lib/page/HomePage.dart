import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }

}

class HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      home:Scaffold(
//        appBar: AppBar(
//          title: Text("首页"),
//          backgroundColor: Color.fromARGB(255, 199, 136, 213),
//          centerTitle: true,
//        ),
//      appBar: PreferredSize(
//        child: Container(
//          width: double.infinity,
//          height: double.infinity,
//          decoration: BoxDecoration(
//            gradient: LinearGradient(colors: [Colors.yellow,Colors.pink]),
//          ),
//          child: SafeArea(child: Text("3423"),),
//        ),
//        preferredSize: Size(double.infinity,60),
//      ),
        body: Center(
          child: Text("首页"),
        ),
      ),


    );
  }

}