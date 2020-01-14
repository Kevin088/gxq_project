import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gxq_project/res/Colors.dart';

typedef DateChangedCallback(double time);
typedef String StringAtIndexCallBack(int index);

class TemperatureSetPage extends StatefulWidget {
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(double i=42.0;i>35.0;i-=0.1){
      dataList.add(i.toStringAsFixed(1));
      widegets1.add(Text(i.toStringAsFixed(1),style: const TextStyle(color: MyColors.color_00286B, fontSize: 18),));
      widegets2.add(Text(i.toStringAsFixed(1),style: const TextStyle(color: Color(0xFF000046), fontSize: 18),));
    }
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
              "温度选择 ",
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

                onPressed: (){

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
      itemExtent: 25.0,
      onSelectedItemChanged: (position){
        leftSelect=position;
      },
      children:widegets1,
      useMagnifier: true,
      backgroundColor:Colors.white,
    );
    return Container(
      height: 300,
      width: 50,
      child:picker1,
    );
  }
  Widget getView2(){

    var picker2  = CupertinoPicker(
      itemExtent: 25.0,
      onSelectedItemChanged: (position){
        rightSelect=position;
      },
      children:widegets2,
      useMagnifier: true,
      backgroundColor:Colors.white,
    );
    return     Container(
      height: 300,
      width: 50,
      child:picker2,
    );
  }
}

