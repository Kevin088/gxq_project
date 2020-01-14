import 'package:banner_view/banner_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qrscaner/flutter_qrscaner.dart';
import 'package:gxq_project/page/mine/ProtocolPage.dart';
import 'package:gxq_project/res/Colors.dart';
import 'package:gxq_project/utils/Toast.dart';
import 'package:gxq_project/utils/Utils.dart';
import 'package:gxq_project/widget/CustomRoute.dart';
import 'package:gxq_project/widget/banner/widget_banner.dart';
import 'package:gxq_project/widget/line/chart_bean.dart';
import 'package:gxq_project/widget/line/chart_line.dart';

import 'DeviceManagePage.dart';
import 'mine/CommonQuestionPage.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int tabButton = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      home: Scaffold(
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
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child:  ClipOval(
                                child: Container(
                                  width: 7,
                                  height: 7,
                                  color: MyColors.color_3464BA,
                                ),
                              ),
                            ),

                             Text(
                                "KHO温度设备名称",
                                style: TextStyle(
                                    fontSize: 19,
                                    color: Color.fromARGB(255, 68, 68, 68)),
                              ),

                            Padding(
                              padding: EdgeInsets.fromLTRB(10,5,0,0),
                              child:  Image.asset(Utils.getImgPath2("ic_arraw_down")),
                            ),
                          ],
                        ),
                      )),
                  Container(
                    child: Container(
                      width: 50,
                      child: FlatButton(
                        onPressed: setting,
                        child: Image.asset(Utils.getImgPath2("ic_setting")),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 100,
              child: getBanner(),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: getTabButton("体温", () {
                      setState(() {
                        tabButton = 0;
                      });
                    }, 0),
                  ),
                  Expanded(
                    flex: 1,
                    child: getTabButton("室温", () {
                      setState(() {
                        tabButton = 1;
                      });
                    }, 1),
                  ),
                  Expanded(
                    flex: 1,
                    child: getTabButton("水温", () {
                      setState(() {
                        tabButton = 2;
                      });
                    }, 2),
                  ),
                ],
              ),
            ),
            currentTemperatureView(),
            Stack(
              children: <Widget>[
                getLineView(context),
                Positioned(
                  right: 25,
                  bottom: 70,
                  child: getHelpButton((){
                    //Navigator.push(context, CustomRoute(CommonQuestionPage()));
                    Navigator.push(context, CustomRoute(ProtocolPage()));

                  }),
                )
              ],
            ),

          ],
        ),
      ),
    );
  }

  Future scan() async {
    FlutterQrscaner.startScan().then((value) {
      Toast.toast(context, msg: value);
    });
  }

  void setting() {
    Toast.toast(context, msg: "设置");
    Navigator.push(context, CustomRoute(DeviceManagePage()));
  }

  Widget getBanner() {
    final List<String> _imgData = [
      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1563852038472&di=de56cb53c9725ec5ee7cc9ea04d3e423&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F0183cb5859e975a8012060c82510f6.jpg",
      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1563815013125&di=6e774e0ec425a5036a9f0b657c6f7d39&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01a949581aeb9fa84a0d304fd05eeb.jpg",
    ];

    return CustomBanner(_imgData);
  }

  Widget getTabButton(String txt, Function press, int index) {
    int index_ = index;
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: new RaisedButton(
        child: new Text(txt),
        color: index_ == tabButton ? MyColors.color_00286B : Colors.white,
        textColor: index_ == tabButton ? Colors.white : Colors.grey,
        onPressed: press,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.white,
        disabledElevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)), //圆角大小
      ),
    );
  }

  Widget currentTemperatureView() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: <Widget>[
          Align(
            alignment: FractionalOffset.centerLeft,
            child: Text(
              "2019-10-18 10:00:00",
              style: TextStyle(
                color: MyColors.gray_999999,
                fontSize: 14,
              ),
            ),
          ),
          Stack(
            children: <Widget>[
              Text(
                "40.5",
                style: TextStyle(
                  color: MyColors.color_DF6565,
                  fontSize: 48,
                ),
              ),
              Align(
                alignment: FractionalOffset.centerRight,
                child: Image.asset(Utils.getImgPath2("ic_wenduji")),
              ),
            ],
          )
        ],
      ),
    );
  }

  ///curve
  Widget getLineView(context) {
    var chartLine = ChartLine(
      chartBeans: [
        ChartBean(x: '12-01', y: 30),
        ChartBean(x: '12-02', y: 88),
        ChartBean(x: '12-03', y: 20),
        ChartBean(x: '12-04', y: 67),
        ChartBean(x: '12-05', y: 10),
        ChartBean(x: '12-06', y: 40),
        ChartBean(x: '12-07', y: 10),
        ChartBean(x: '12-08', y: 30),
        ChartBean(x: '12-09', y: 88),
        ChartBean(x: '12-10', y: 20),
        ChartBean(x: '12-11', y: 67),
        ChartBean(x: '12-12', y: 10),
        ChartBean(x: '12-13', y: 40),
        ChartBean(x: '12-14', y: 10),
      ],
      size: Size(MediaQuery.of(context).size.width, 180),
      isCurve: true,
      lineWidth: 2,
      lineColor: MyColors.color_00286B_,
      fontColor: MyColors.color_444444,
      xyColor: MyColors.color_dddddd,
      shaderColors: [
        Colors.blueAccent.withOpacity(0.3),
        Colors.blueAccent.withOpacity(0.1)
      ],
      fontSize: 12,
      yNum: 8,
      isAnimation: true,
      isReverse: false,
      isCanTouch: true,
      isShowPressedHintLine: true,
      pressedPointRadius: 4,
      pressedHintLineWidth: 1,
      pressedHintLineColor: MyColors.color_dddddd,
      duration: Duration(milliseconds: 2000),
    );
    return Container(
      margin: EdgeInsets.only(left: 0, right: 16, top: 20, bottom: 0),
      child: chartLine,
    );
  }



  Widget getHelpButton( Function press) {
    return Container(
      width: 110,
      height: 35,
      child: new RaisedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(Utils.getImgPath2("ic_help")),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                "使用帮助",
                style: TextStyle(
                    color: MyColors.color_444444,
                    fontSize: 12
                ),
              )
            ),

          ],
        ),
        color:  Colors.white,
        onPressed: press,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)), //圆角大小
      ),
    );
  }
}
