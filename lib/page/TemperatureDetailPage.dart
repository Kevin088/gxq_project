import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gxq_project/res/Colors.dart';
import 'package:gxq_project/utils/Utils.dart';
import 'package:gxq_project/widget/line/chart_bean.dart';
import 'package:gxq_project/widget/line/chart_line.dart';

class TemperatureDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TemperatureDetailState();
  }
}

class TemperatureDetailState extends State<TemperatureDetailPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          color: MyColors.color_DF6565,
          height: 230,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  child: Image.asset(Utils.getImgPath2("ic_back")),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "体温警报",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "40.5℃",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "2019/12/31 13:00:00 ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          "最低体温",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(Utils.getImgPath2("ic_wendu_down")),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              "36.9",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                            Container(
                              height: 22,
                              child: Text(
                                "℃",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        SizedBox(
                          width: 50,
                          height: 0.5,
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "最高体温",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(Utils.getImgPath2("ic_wendu_up")),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              "36.9",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                            Container(
                              height: 22,
                              child: Text(
                                "℃",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: getView1(),
        ),
        getLineView(context),
      ],
    ));
  }

  Widget getView1() {
    return Row(
      children: <Widget>[
        Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Container(
                color: MyColors.color_DF6565,
                width: 4,
                height: 80,
              ),
            ),
            ClipOval(
              child: Container(
                width: 12,
                height: 12,
                color: MyColors.color_DF6565,
              ),
            ),
            Positioned(
                bottom: 0,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    ClipOval(
                      child: Container(
                        width: 12,
                        height: 12,
                        color: MyColors.color_DF6565,
                      ),
                    ),
                    ClipOval(
                      child: Container(
                        width: 6,
                        height: 6,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ))
          ],
        ),
        SizedBox(
          width: 20,
        ),
        Container(
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "开始时间 ",
                style: TextStyle(color: MyColors.gray_999999, fontSize: 12),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                "2019-12-31 09:37:55 ",
                style: TextStyle(color: MyColors.color_444444, fontSize: 16),
              ),
              Expanded(
                child: Container(),
              ),
              Text(
                "结束时间  ",
                style: TextStyle(color: MyColors.gray_999999, fontSize: 12),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                "2019-12-31 09:37:55 ",
                style: TextStyle(color: MyColors.color_444444, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
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
      lineColor: MyColors.color_DF6565,
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
}
