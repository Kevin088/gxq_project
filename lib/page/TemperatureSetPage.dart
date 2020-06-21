import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gxq_project/bean/StartEvent.dart';
import 'package:gxq_project/common/param_name.dart';
import 'package:gxq_project/res/Colors.dart';
import 'package:gxq_project/utils/Toast.dart';
import 'package:gxq_project/utils/event_bus.dart';
import 'package:rammus/rammus.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef DateChangedCallback(double time);
typedef String StringAtIndexCallBack(int index);

class TemperatureSetPage extends StatefulWidget {

  bool isCaiJIng=false;
  int index=0;
  TemperatureSetPage({Key key,  this.isCaiJIng,this.index})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TemperatureSetPageState();
  }
}

class TemperatureSetPageState extends State<TemperatureSetPage> {

  List<String> dataList=List();
  List<Widget> widegets1=List<Widget>();
  List<Widget> widegets2=List<Widget>();
  int leftSelect=0;
  int rightSelect=0;
  var controller1=FixedExtentScrollController();
  var controller2=FixedExtentScrollController();
  @override
  void initState() {
    super.initState();
    for(double i=65.0;i>=0;i-=0.1){
      dataList.add(i.toString());
      widegets1.add(Text(i.toStringAsFixed(1),style: const TextStyle(color: MyColors.color_00286B, fontSize: 18),));
      widegets2.add(Text(i.toStringAsFixed(1),style: const TextStyle(color: Color(0xFF000046), fontSize: 18),));
    }

    initData();
  }
  initData() async {
    var prefs = await SharedPreferences.getInstance();
    if(!mounted){
      return;
    }
    double lowValue=prefs.getDouble(ParamName.SP_LOW_TEMP_PEOPLE)??35;
    double hightValue=prefs.getDouble(ParamName.SP_HIGH_TEMP_PEOPLE)??39;
    if(widget.index==1){
       lowValue=prefs.getDouble(ParamName.SP_LOW_TEMP_ROOM)??15;
       hightValue=prefs.getDouble(ParamName.SP_HIGH_TEMP_ROOM)??36;
    }else if(widget.index==2){
       lowValue=prefs.getDouble(ParamName.SP_LOW_TEMP_WATER)??20;
       hightValue=prefs.getDouble(ParamName.SP_HIGH_TEMP_WATER)??45;
    }



    controller1.animateToItem(((65-lowValue)*10).round(),
        duration: Duration(milliseconds: 600), curve: Curves.ease);
    controller2.animateToItem(((65-hightValue)*10).round(),
        duration: Duration(milliseconds: 600), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            SizedBox(height: 30,),
            Text(
              (widget.isCaiJIng?"停止采集":"开始采集"),
              style: TextStyle(color: MyColors.color_444444,fontSize: 19,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50,),
             Row(
               children: <Widget>[
                 Expanded(
                   child: Container(),
                   flex: 1,
                 ),
                 getView1(),
                 Expanded(
                   child: Container(),
                   flex: 1,
                 ),
                 Padding(
                   padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                   child:Text(
                     "℃",
                     style: TextStyle(color: MyColors.color_00286B,fontSize:18 ,fontWeight: FontWeight.bold),
                   ),
                 ),

                 Expanded(
                   child: Container(),
                   flex: 1,
                 ),
                 Padding(
                   padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                   child:Text(
                     "至",
                     style: TextStyle(color: MyColors.color_00286B,fontSize:18 ,fontWeight: FontWeight.bold),
                   ),
                 ),
                 Expanded(
                   child: Container(),
                   flex: 1,
                 ),
                 getView2(),
                 Expanded(
                   child: Container(),
                   flex: 1,
                 ),
                 Padding(
                   padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                   child:Text(
                     "℃",
                     style: TextStyle(color: MyColors.color_00286B,fontSize:18 ,fontWeight: FontWeight.bold),
                   ),
                 ),

                 Expanded(
                   child: Container(),
                   flex: 1,
                 ),
               ],
             ),

            SizedBox(height: 20,),
            Container(
              width: 300,
              height: 45,
              child:RaisedButton(
                child: new Text(!widget.isCaiJIng?"开始检测":"检测完毕",
                  style: TextStyle(fontSize: 16),
                ),
                color: MyColors.color_00286B ,
                textColor: Colors.white ,

                onPressed: () async {
                  double leftValue=double.parse(dataList[leftSelect]);
                  double rightValue=double.parse(dataList[rightSelect]);
                  if(leftValue>=rightValue){
                    Toast.toast(context,msg: "温度设置错误");
                  }else{
                    var prefs = await SharedPreferences.getInstance();
                    if(widget.index==0){
                         prefs.setDouble(ParamName.SP_LOW_TEMP_PEOPLE, NumUtil.getNumByValueDouble(leftValue, 1));
                         prefs.setDouble(ParamName.SP_HIGH_TEMP_PEOPLE,NumUtil.getNumByValueDouble(rightValue, 1));
                    }else if(widget.index==1){
                      prefs.setDouble(ParamName.SP_LOW_TEMP_ROOM, NumUtil.getNumByValueDouble(leftValue, 1));
                      prefs.setDouble(ParamName.SP_HIGH_TEMP_ROOM,NumUtil.getNumByValueDouble(rightValue, 1));
                    }else{
                      prefs.setDouble(ParamName.SP_LOW_TEMP_WATER, NumUtil.getNumByValueDouble(leftValue, 1));
                      prefs.setDouble(ParamName.SP_HIGH_TEMP_WATER,NumUtil.getNumByValueDouble(rightValue, 1));
                    }
                    StartEvent event=new StartEvent();
                    event.isCaijing=widget.isCaiJIng;
                    eventBus.fire(event);
                    Navigator.pop(context);
                  }
                  print(dataList[leftSelect]+"========"+dataList[rightSelect]);


                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)), //圆角大小
              ),
            ),
            SizedBox(height: 20,),
            Container(
              width: 300,
              height: 45,
              child:RaisedButton(
                child: new Text("取消",
                  style: TextStyle(fontSize: 16),
                ),
                color: MyColors.color_00286B ,
                textColor: Colors.white ,
                onPressed: () async {
                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)), //圆角大小
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget getView1(){

    var picker1  = CupertinoPicker(
      itemExtent: 28.0,
      onSelectedItemChanged: (position){
        leftSelect=position;
      },
      children:widegets1,
      useMagnifier: true,
      backgroundColor:Colors.white,
        scrollController:controller1

    );
    return Column(
      children: <Widget>[
        Text("最低温",
          style: TextStyle(color: MyColors.color_444444,fontSize: 16,fontWeight: FontWeight.bold),
        ),
        Container(
          height: 300,
          width: 50,
          child:picker1,
        )
      ],
    );
  }
  Widget getView2(){

    var picker2  = CupertinoPicker(
      itemExtent: 28.0,
      onSelectedItemChanged: (position){
        rightSelect=position;
      },
      children:widegets2,
      useMagnifier: true,
      backgroundColor:Colors.white,
        scrollController:controller2
    );
    return   Column(
      children: <Widget>[
        Text("最高温",
          style: TextStyle(color: MyColors.color_444444,fontSize: 16,fontWeight: FontWeight.bold),
        ),
        Container(
          height: 300,
          width: 50,
          child:picker2,
        )
      ],
    );
  }
}

