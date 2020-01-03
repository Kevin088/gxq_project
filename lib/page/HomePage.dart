import 'package:banner_view/banner_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qrscaner/flutter_qrscaner.dart';
import 'package:gxq_project/utils/Toast.dart';
import 'package:gxq_project/utils/Utils.dart';
import 'package:gxq_project/widget/banner/widget_banner.dart';
class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }

}

class HomePageState extends State<HomePage>{
  int tabButton=0;
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
        body: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                    width: 50,
                    child: FlatButton(
                      onPressed: scan,
                      child: Image.asset(Utils.getImgPath2("ic_saoyisao")),
                    ),
                  ),
                  Expanded(

                    child:Center(
                      child:  Text(
                        "KHO温度设备名称",
                        style: TextStyle(
                            fontSize: 19,
                            color: Color.fromARGB(255, 68, 68, 68)
                        ),
                      ),
                    )
                  ),
                  Container(
                    width: 50,
                    child: FlatButton(
                      onPressed: setting,
                      child: Image.asset(Utils.getImgPath2("ic_setting")),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 100,
              child: getBanner(),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
              child:        Row(
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child:getTabButton("体温",(){
                      setState(() {
                        tabButton=0;
                      });                    },0),
                  ),
                  Expanded(
                    flex:1,
                    child:getTabButton("室温",(){
                      setState(() {
                        tabButton=1;
                      });
                    },1),
                  ),
                  Expanded(
                    flex:1,
                    child:getTabButton("水温",(){
                      setState(() {
                        tabButton=2;
                      });
                    },2),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),


    );
  }
  Future scan() async {
    FlutterQrscaner.startScan().then((value) {
      Toast.toast(context,msg:value);
    });
  }
  void setting() {
     Toast.toast(context,msg:"设置");
  }


  Widget getBanner(){
    final List<String> _imgData = [
      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1563852038472&di=de56cb53c9725ec5ee7cc9ea04d3e423&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F0183cb5859e975a8012060c82510f6.jpg",
      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1563815013125&di=6e774e0ec425a5036a9f0b657c6f7d39&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01a949581aeb9fa84a0d304fd05eeb.jpg",
    ];

    return CustomBanner(_imgData);
  }

  Widget getTabButton(String txt,Function press,int index){
    int index_=index;
    return  Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: new RaisedButton(
        child: new Text(txt),
        color: index_==tabButton?Colors.blue:Colors.white,
        textColor: index_==tabButton?Colors.white:Colors.grey,
        onPressed: press,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.white,
        disabledElevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //圆角大小
      ),
    );
  }


}