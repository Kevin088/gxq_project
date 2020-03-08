

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gxq_project/res/Colors.dart';
import 'package:gxq_project/utils/Utils.dart';

import 'package:shared_preferences/shared_preferences.dart';


// ignore: must_be_immutable
class SetPage extends StatefulWidget{
  bool isOpen1=true;
  bool isOpen2=true;
  bool isOpen3=true;
  bool isOpen4=true;
  bool isOpen5=true;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState


    return SetPageState();
  }

}

class SetPageState extends State<SetPage>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

  }

  void getData() async{
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      widget.isOpen1=prefs.getBool("DeviceDisconnectedTip")??true;
      widget.isOpen2=prefs.getBool("DeviceConnectedTip")??true;
      widget.isOpen3=prefs.getBool("HotTip")??true;
      widget.isOpen4=prefs.getBool("LOWTip")??true;
      widget.isOpen5=prefs.getBool("BatteryTip")??true;
    });
  }

  @override
  Widget build(BuildContext context) {




    // TODO: implement build
    return Scaffold(
      body: Column(
        crossAxisAlignment : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(20, 30, 0, 0),
            child: GestureDetector(
              child: Image.asset(Utils.getImgPath2("ic_back")),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
            child: Text(
              "提醒设置",
              style: TextStyle(
                  fontSize: 28,
                  color: Color.fromARGB(255, 0, 0, 0)
              ),
            ),
          ),
          Container(
            height: 10,
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            color: Color.fromARGB(255, 238, 238, 238),
          ),
          Container(
            height: 61,
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: <Widget>[
                Text(
                  "设备断开提醒",
                  style: TextStyle(
                    color: MyColors.color_444444,
                    fontSize: 15,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Switch(
                  value: widget.isOpen1,
                  activeColor: MyColors.color_00286B,
                  inactiveThumbColor:MyColors.color_D4D4D4,
                  onChanged: (value)  async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool("DeviceDisconnectedTip", value);
                    print("==1111==$widget.isOpen1");
                    setState(() {
                      widget.isOpen1=value;
                    });
                  },
                  activeTrackColor:MyColors.color_D0D0D0,
                  inactiveTrackColor:MyColors.color_D0D0D0,
                )
              ],
            ),
          ),
          Divider(height: 1.0,color: MyColors.color_divider,indent: 20,endIndent: 20,),
          Container(
            height: 61,
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: <Widget>[
                Text(
                  "设备连接提醒",
                  style: TextStyle(
                    color: MyColors.color_444444,
                    fontSize: 15,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Switch(
                  value: widget.isOpen2,
                  activeColor: MyColors.color_00286B,
                  inactiveThumbColor:MyColors.color_D4D4D4,
                  onChanged: (value) async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool("DeviceConnectedTip", value);
                   // SpUtil.putBool("DeviceConnectedTip",value);
                    setState(() {
                      widget.isOpen2=value;
                    });
                  },
                  activeTrackColor:MyColors.color_D0D0D0,
                  inactiveTrackColor:MyColors.color_D0D0D0,
                )
              ],
            ),
          ),
          Divider(height: 1.0,color: MyColors.color_divider,indent: 20,endIndent: 20,),
          Container(
            height: 61,
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: <Widget>[
                Text(
                  "高温提醒",
                  style: TextStyle(
                    color: MyColors.color_444444,
                    fontSize: 15,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Switch(
                  value: widget.isOpen3,
                  activeColor: MyColors.color_00286B,
                  inactiveThumbColor:MyColors.color_D4D4D4,
                  onChanged: (value)  async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool("HotTip", value);
                   // SpUtil.putBool("HotTip",value);
                    setState(() {
                      widget.isOpen3=value;
                    });
                  },
                  activeTrackColor:MyColors.color_D0D0D0,
                  inactiveTrackColor:MyColors.color_D0D0D0,
                )
              ],
            ),
          ),
          Divider(height: 1.0,color: MyColors.color_divider,indent: 20,endIndent: 20,),
          Container(
            height: 61,
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: <Widget>[
                Text(
                  "低温提醒",
                  style: TextStyle(
                    color: MyColors.color_444444,
                    fontSize: 15,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Switch(
                  value: widget.isOpen4,
                  activeColor: MyColors.color_00286B,
                  inactiveThumbColor:MyColors.color_D4D4D4,
                  onChanged: (value) async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool("LOWTip", value);
                    //SpUtil.putBool("LOWTip",value);
                    setState(() {
                      widget.isOpen4=value;
                    });
                  },
                  activeTrackColor:MyColors.color_D0D0D0,
                  inactiveTrackColor:MyColors.color_D0D0D0,
                )
              ],
            ),
          ),
          Divider(height: 1.0,color: MyColors.color_divider,indent: 20,endIndent: 20,),
          Container(
            height: 61,
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: <Widget>[
                Text(
                  "电量过低提醒",
                  style: TextStyle(
                    color: MyColors.color_444444,
                    fontSize: 15,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Switch(
                  value: widget.isOpen5,
                  activeColor: MyColors.color_00286B,
                  inactiveThumbColor:MyColors.color_D4D4D4,
                  onChanged: (value) async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool("BatteryTip", value);
                    //SpUtil.putBool("BatteryTip",value);
                    setState(() {
                      widget.isOpen5=value;

                    });
                  },
                  activeTrackColor:MyColors.color_D0D0D0,
                  inactiveTrackColor:MyColors.color_D0D0D0,
                )
              ],
            ),
          ),
          Divider(height: 1.0,color: MyColors.color_divider,indent: 20,endIndent: 20,),


        ],
      ),
    );
  }

}