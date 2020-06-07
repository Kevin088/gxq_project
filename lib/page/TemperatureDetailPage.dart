import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gxq_project/bean/point_info.dart';
import 'package:gxq_project/res/Colors.dart';
import 'package:gxq_project/utils/Utils.dart';
import 'package:gxq_project/widget/line/chart_bean.dart';
import 'package:gxq_project/widget/line/chart_line.dart';

class TemperatureDetailPage extends StatefulWidget {
  PointInfo pointInfo;
  TemperatureDetailPage({Key key, @required this.pointInfo})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TemperatureDetailState();
  }
}

class TemperatureDetailState extends State<TemperatureDetailPage> {

  List<ChartBean>listData=List();
  var startTime;
  var endTime;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var list=jsonDecode(widget.pointInfo?.detailInfo);
    listData.addAll(ChartBean.fromMapList(list));

  }
  @override
  Widget build(BuildContext context) {
    var title;
    var temp;
    if(widget.pointInfo.status==0){
      title="体温正常";
      temp=widget.pointInfo.tempValueAverage;
    } else if(widget.pointInfo.status==2){
      title="体温中断";
      temp=widget.pointInfo.tempValueAverage;
    }else if(widget.pointInfo.status==1){
      title="体温报警";
      temp=widget.pointInfo.tempValueMax;
    }

    if(listData.length>0){
      startTime=Utils.formatTime(listData[0]?.millisSeconds);
      endTime=Utils.formatTime(listData[listData.length-1]?.millisSeconds);
    }
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
                          title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "$temp℃",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          Utils.formatTime(widget.pointInfo.createTime),
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
                              widget.pointInfo.tempValueMin,
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
                              widget.pointInfo.tempValueMax,
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
                startTime,
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
                endTime,
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
      chartBeans: listData,
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
