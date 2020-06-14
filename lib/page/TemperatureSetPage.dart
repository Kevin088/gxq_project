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
  bool isReview=false;
  TemperatureSetPage({Key key,  this.isCaiJIng,this.isReview})
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
    for(double i=55.0;i>24.9;i-=0.1){
      dataList.add(i.toString());
      widegets1.add(Text(i.toStringAsFixed(1),style: const TextStyle(color: MyColors.color_00286B, fontSize: 18),));
      widegets2.add(Text(i.toStringAsFixed(1),style: const TextStyle(color: Color(0xFF000046), fontSize: 18),));
    }

    initData();

//    WidgetsBinding.instance.addPostFrameCallback((mag) {
//      controller1.animateToItem(250,
//          duration: Duration(milliseconds: 600), curve: Curves.ease);
//      controller2.animateToItem(250,
//          duration: Duration(milliseconds: 600), curve: Curves.ease);
//    });


  }
  initData() async {
    var prefs = await SharedPreferences.getInstance();
    if(!mounted){
      return;
    }
    double lowValue=prefs.getDouble(ParamName.SP_LOW_TEMP)??34;
    double hightValue=prefs.getDouble(ParamName.SP_HIGH_TEMP)??40;

    controller1.animateToItem(((55-lowValue)*10).round(),
        duration: Duration(milliseconds: 600), curve: Curves.ease);
    controller2.animateToItem(((55-hightValue)*10).round(),
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
              widget.isReview?"温度设置":(widget.isCaiJIng?"停止采集":"开始采集"),
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
                 Text(
                   "℃",
                   style: TextStyle(color: MyColors.color_00286B,fontSize:18 ,fontWeight: FontWeight.bold),
                 ),
                 Expanded(
                   child: Container(),
                   flex: 1,
                 ),
                 Text(
                   "至",
                   style: TextStyle(color: MyColors.color_00286B,fontSize:18 ,fontWeight: FontWeight.bold),
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
                 Text(
                   "℃",
                   style: TextStyle(color: MyColors.color_00286B,fontSize:18 ,fontWeight: FontWeight.bold),
                 ),
                 Expanded(
                   child: Container(),
                   flex: 1,
                 ),
               ],
             ),

            SizedBox(height: 50,),
            Container(
              width: 300,
              height: 45,
              child:RaisedButton(
                child: new Text("确定",style: TextStyle(fontSize: 16),),
                color: MyColors.color_00286B ,
                textColor: Colors.white ,

                onPressed: () async {
                  double leftValue=double.parse(dataList[leftSelect]);
                  double rightValue=double.parse(dataList[rightSelect]);
                  if(leftValue>=rightValue){
                    Toast.toast(context,msg: "温度设置错误");
                  }else{
                    var prefs = await SharedPreferences.getInstance();
                    prefs.setDouble(ParamName.SP_LOW_TEMP, NumUtil.getNumByValueDouble(leftValue, 1));
                    prefs.setDouble(ParamName.SP_HIGH_TEMP,NumUtil.getNumByValueDouble(rightValue, 1));
                    if(!widget.isReview){
                      StartEvent event=new StartEvent();
                      event.isCaijing=widget.isCaiJIng;
                      eventBus.fire(event);
                    }
                    Navigator.pop(context);
                  }
                  print(dataList[leftSelect]+"========"+dataList[rightSelect]);


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
    return Container(
      height: 300,
      width: 50,
      child:picker1,
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
    return     Container(
      height: 300,
      width: 50,
      child:picker2,
    );
  }
}

