import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gxq_project/res/Colors.dart';

class DatePickerTheme extends Diagnosticable {
  final TextStyle cancelStyle;
  final TextStyle doneStyle;
  final TextStyle itemStyle;
  final Color backgroundColor;
  final Color headerColor;

  final double containerHeight;
  final double titleHeight;
  final double itemHeight;

  const DatePickerTheme({
    this.cancelStyle = const TextStyle(color: Colors.black54, fontSize: 16),
    this.doneStyle = const TextStyle(color: Colors.blue, fontSize: 16),
    this.itemStyle = const TextStyle(color: MyColors.color_00286B, fontSize: 18),
    this.backgroundColor = Colors.white,
    this.headerColor,
    this.containerHeight = 410.0,
    this.titleHeight = 44.0,
    this.itemHeight = 36.0,
  });
}
