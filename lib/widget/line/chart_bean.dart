import 'package:flutter/material.dart';

class ChartBean {
  String x;
  double y;
  int millisSeconds;
  Color color;

  ChartBean(
      {@required this.x, @required this.y, this.millisSeconds, this.color});

  Map toJson() {
    Map map = new Map();
    map["x"] = this.x;
    map["y"] = this.y;
    map["millisSeconds"] = this.millisSeconds;
    return map;
  }
  static ChartBean fromMap(Map<String, dynamic> map) {
    ChartBean jsonModelDemo = new ChartBean();
    jsonModelDemo.x = map['x'];
    jsonModelDemo.y = map['y'];
    jsonModelDemo.millisSeconds = map['millisSeconds'];
    return jsonModelDemo;
  }

  static List<ChartBean> fromMapList(dynamic mapList) {
    List<ChartBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}
