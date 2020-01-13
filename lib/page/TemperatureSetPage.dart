import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gxq_project/widget/pickview/date_model.dart';
import 'package:gxq_project/widget/pickview/datetime_picker_theme.dart';
import 'package:gxq_project/widget/pickview/i18n_model.dart';

typedef DateChangedCallback(DateTime time);
typedef String StringAtIndexCallBack(int index);

class TemperatureSetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TemperatureSetPageState();
  }
}

class TemperatureSetPageState extends State<TemperatureSetPage> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      home: Scaffold(
        body: _DatePickerComponent(
            onChanged: (date){
              print('change $date in time zone ' +
                  date.timeZoneOffset.inHours.toString());
            },
            pickerModel: DateTimePickerModel(
                minTime: DateTime(2020, 5, 5, 20, 50),
                maxTime: DateTime(2020, 6, 7, 05, 09),
                )
        ),
      ),
    );
  }
}

class _DatePickerComponent extends StatefulWidget {
  _DatePickerComponent(
      {Key key,
        this.onChanged,
        this.pickerModel});

  final DateChangedCallback onChanged;



  final BasePickerModel pickerModel;

  @override
  State<StatefulWidget> createState() {
    return _DatePickerState();
  }
}

class  _DatePickerState extends State<_DatePickerComponent> {
  FixedExtentScrollController leftScrollCtrl, middleScrollCtrl, rightScrollCtrl;

  @override
  void initState() {
    super.initState();
    refreshScrollOffset();
  }

  void refreshScrollOffset() {
    leftScrollCtrl = new FixedExtentScrollController(
        initialItem: widget.pickerModel.currentLeftIndex());
    middleScrollCtrl = new FixedExtentScrollController(
        initialItem: widget.pickerModel.currentMiddleIndex());
    rightScrollCtrl = new FixedExtentScrollController(
        initialItem: widget.pickerModel.currentRightIndex());
  }

  @override
  Widget build(BuildContext context) {

    return _renderItemView(DatePickerTheme());
  }

  void _notifyDateChanged() {
    if (widget.onChanged != null) {
      widget.onChanged(widget.pickerModel.finalTime());
    }
  }



  Widget _renderColumnView(
      ValueKey key,
      DatePickerTheme theme,
      StringAtIndexCallBack stringAtIndexCB,
      ScrollController scrollController,
      int layoutProportion,
      ValueChanged<int> selectedChangedWhenScrolling,
      ValueChanged<int> selectedChangedWhenScrollEnd) {
    return Expanded(
      flex: layoutProportion,
      child: Container(
          padding: EdgeInsets.all(8.0),
          height: theme.containerHeight,
          decoration:
          BoxDecoration(color: theme.backgroundColor ?? Colors.white),
          child: NotificationListener(
              onNotification: (ScrollNotification notification) {
                if (notification.depth == 0 &&
                    selectedChangedWhenScrollEnd != null &&
                    notification is ScrollEndNotification &&
                    notification.metrics is FixedExtentMetrics) {
                  final FixedExtentMetrics metrics = notification.metrics;
                  final int currentItemIndex = metrics.itemIndex;
                  selectedChangedWhenScrollEnd(currentItemIndex);
                }
                return false;
              },
              child: CupertinoPicker.builder(
                  key: key,
                  backgroundColor: theme.backgroundColor ?? Colors.white,
                  scrollController: scrollController,
                  itemExtent: theme.itemHeight,
                  onSelectedItemChanged: (int index) {
                    selectedChangedWhenScrolling(index);
                  },
                  useMagnifier: true,
                  itemBuilder: (BuildContext context, int index) {
                    final content = stringAtIndexCB(index);
                    if (content == null) {
                      return null;
                    }
                    return Container(
                      height: theme.itemHeight,
                      alignment: Alignment.center,
                      child: Text(
                        content,
                        style: theme.itemStyle,
                        textAlign: TextAlign.start,
                      ),
                    );
                  }))),
    );
  }

  Widget _renderItemView(DatePickerTheme theme) {
    return Container(
      color:  Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child:  _renderColumnView(
                ValueKey(widget.pickerModel.currentLeftIndex()),
                theme,
                widget.pickerModel.leftStringAtIndex,
                leftScrollCtrl,
                widget.pickerModel.layoutProportions()[0],
                    (index) {
                  widget.pickerModel.setLeftIndex(index);
                }, (index) {
              setState(() {
                refreshScrollOffset();
                _notifyDateChanged();
              });
            }),
          ),
          Text(
            widget.pickerModel.leftDivider(),
            style: theme.itemStyle,
          ),
          Container(
            child: _renderColumnView(
                ValueKey(widget.pickerModel.currentLeftIndex()),
                theme,
                widget.pickerModel.middleStringAtIndex,
                middleScrollCtrl,
                widget.pickerModel.layoutProportions()[1], (index) {
              widget.pickerModel.setMiddleIndex(index);
            }, (index) {
              setState(() {
                refreshScrollOffset();
                _notifyDateChanged();
              });
            }),
          ),
          Text(
            widget.pickerModel.rightDivider(),
            style: theme.itemStyle,
          ),
          Container(
            child:  _renderColumnView(
                ValueKey(widget.pickerModel.currentMiddleIndex() * 100 +
                    widget.pickerModel.currentLeftIndex()),
                theme,
                widget.pickerModel.rightStringAtIndex,
                rightScrollCtrl,
                widget.pickerModel.layoutProportions()[2], (index) {
              widget.pickerModel.setRightIndex(index);
              _notifyDateChanged();
            }, null),
          ),
        ],
      ),
    );
  }
}
