import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_qrscaner/flutter_qrscaner.dart';
import 'package:gxq_project/bean/banner_info.dart';
import 'package:gxq_project/bean/point_info.dart';
import 'package:gxq_project/common/api.dart';
import 'package:gxq_project/common/param_name.dart';
import 'package:gxq_project/db/database_helper.dart';
import 'package:gxq_project/http/httpUtil.dart';
import 'package:gxq_project/page/test/LearnDropdownButton.dart';
import 'package:gxq_project/res/Colors.dart';
import 'package:gxq_project/utils/Toast.dart';
import 'package:gxq_project/utils/Utils.dart';
import 'package:gxq_project/widget/CustomRoute.dart';
import 'package:gxq_project/widget/banner/widget_banner.dart';
import 'package:gxq_project/widget/line/chart_bean.dart';
import 'package:gxq_project/widget/line/chart_line.dart';
import 'package:rammus/rammus.dart' as rammus; //导包
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'TemperatureSetPage.dart';
import 'mine/AboutPage.dart';
import 'mine/CommonQuestionPage.dart';
import 'mine/SetPage.dart';


class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  int tabButton = 0;
  String _deviceId="";
  //List<BluetoothDevice> devices = List<BluetoothDevice>();


  double xPosition = 0;
  double yPosition = 0;

  final GlobalKey globalKey = GlobalKey();


  var value='1';



  String UUID="0000fff6-0000-1000-8000-00805f9b34fb";

  BluetoothCharacteristic bluetoothCharacteristic;
  BluetoothDevice bluetoothDevice;

  String currentTime="";
  String currentTemperature="0";

  //设备
  List<BluetoothDevice> devicelist=List();

  List<ChartBean>listData=List();

  bool isCaiJing=false;


  String blueToothId="";
  String blueToothName="设备连接中...";
  //banner
  List<String> _imgData =List<String>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();



    //推送通知的处理 (注意，这里的id:针对Android8.0以上的设备来设置通知通道,客户端的id跟阿里云的通知通道要一致，否则收不到通知)
    rammus.setupNotificationManager(id: "1",name: "rammus",description: "rammus test",);
    rammus.onNotification.listen((data){
      print("-=============>notification here ${data.summary}");
    });
    rammus.onNotificationOpened.listen((data){//这里是点击通知栏回调的方法
      print("-=============> ${data.summary} 被点了");
      //点击通知后跳转的页面
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (ctx) => new HomePage()));
    });

    rammus.onNotificationRemoved.listen((data){
      print("-=============> $data 被删除了");
    });

    rammus.onNotificationReceivedInApp.listen((data){
      print("-ReceivedInApp=============>${data.summary} In app");
    });

    rammus.onNotificationClickedWithNoAction.listen((data){
      print("${data.summary} no action-=============>");
    });

    rammus.onMessageArrived.listen((data){
      print("received data -=============> ${data.content}");
    });

    initPlatformState();
    //蓝牙=====================================

    FlutterBlue flutterBlue = FlutterBlue.instance;

    // Start scanning
    flutterBlue.startScan(timeout: Duration(seconds: 60*60));

// Listen to scan results
    flutterBlue.scanResults.listen((results) async {
      // do something with scan results
      for (ScanResult r in results) {
        devicelist.add(r.device);
        if(r.device.name.contains("Rdf")&&bluetoothDevice==null){
          bluetoothDevice=r.device;
          print('${r.device.name} found! rssi: ${r.rssi}');
          //flutterBlue.stopScan();
          //await r.device.disconnect();
          await r.device.connect();
          print("已连接======= -=============>");
          blueToothId=r.device.id.id;
          setState(() {
            blueToothName=r.device.name;
          });
          List<BluetoothService> services = await r.device.discoverServices();
          services.forEach((service) {
            var characteristics = service.characteristics;
            print("${service.uuid}================service========");
            characteristics.forEach((characteristic) {
              print("${characteristic.uuid}================charact========");
              if(UUID.compareTo(characteristic.uuid.toString().toLowerCase())==0){
                bluetoothCharacteristic=characteristic;
                //bluetoothCharacteristic.write([0xFB,0x02,0x00,0x00]);
                print("${bluetoothCharacteristic.uuid}================charact===相等=====");
              }
            });

          });
          if(bluetoothCharacteristic!=null){
            print("================bluetoothCharacteristic!=null========");
            await bluetoothCharacteristic.setNotifyValue(true);
            bluetoothCharacteristic.value.listen((value) {
              currentTemperature=Utils.getTemperature(value);
              print("${Utils.getTemperature(value)}℃================$value========");

            });
          }
          break;
        }
      }
      if(devicelist.length>0){
        setState(() {

        });
      }
    });
// Stop scanning
    //  flutterBlue.stopScan();


    initData();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // ignore: unrelated_type_equality_checks
    if(bluetoothDevice!=null&&bluetoothDevice.state==BluetoothDeviceState.connected){
      bluetoothDevice.disconnect();
    }
    print("===dispose==================");
    cancelTimer();
  }


  //获取device id的方法
  Future<void> initPlatformState() async {
    String deviceId;
    try {
      deviceId = await rammus.deviceId;
    } on PlatformException {
      deviceId = 'Failed to get device id.';
    }
    print("===deviceId========>$deviceId");
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(ParamName.DEVICE_ID,deviceId);
//    if (!mounted) return;
//    setState(() {
//      _deviceId = deviceId;
//      //接下来你要做的事情
//      //1.将device id通过接口post给后台，然后进行指定设备的推送
//      //2.推送的时候，在Android8.0以上的设备都要设置通知通道
//
//    });
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    if(xPosition==0){
      xPosition = MediaQuery.of(context).size.width-130;

    }

    return new MaterialApp(
        home: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Scaffold(
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
                            child: getDropDownMenu(),
                          )),
                      Container(
                        child: Container(
                          width: 50,
                          child: FlatButton(
                            onPressed: (){
                              Navigator.push(context, CustomRoute(TemperatureSetPage()));

                            },
                            child: Image.asset(Utils.getImgPath2("ic_setting")),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  child: _imgData.length>0?getBanner():Container(),
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
                      left: xPosition,
                      top: yPosition,
                      child: GestureDetector(
                          onPanUpdate: (detail){
                            double x=xPosition;
                            x += detail.delta.dx;
                            if(x>0&&x<MediaQuery.of(context).size.width-110){
                              setState(() {
                                xPosition=x;
                              });
                            }

                            double y=yPosition;
                            y += detail.delta.dy;
                            if(y<150&&y>0){
                              setState(() {
                                yPosition=y;
                              });
                            }
                          },
                          onPanEnd: (detail){

                          },
                          child:getHelpButton((){
                            Navigator.push(context, CustomRoute(CommonQuestionPage()));
                            //bluetoothCharacteristic.write([0xFB, 0x03, 0x00, 0x00]);
                          })
                      ),
                    )
                  ],
                ),

              ],
            ),
          ),
        )
    );

  }

  Future scan() async {
    FlutterQrscaner.startScan().then((value) {
      Toast.toast(context, msg: value);
    });
  }
  //设置
  void setting() {
    if(!isCaiJing){
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('开始采集'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      timeStart();
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                    child: Text('确认'),
            padding: EdgeInsets.fromLTRB(5,3,3,5),
            )),
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                        child: Text('取消'),
                        padding: EdgeInsets.fromLTRB(5,3,3,5),
                    )),
              ],
            );
          });
    }else{
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('结束采集'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      cancelTimer();
                      setState(() {

                      });
                      _saveData(listData);
                    },
                    child: Padding(
                      child: Text('确定'),
                      padding: EdgeInsets.all(4),
                    )
                ),
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child:Padding(
                      child:  Text('取消'),
                      padding: EdgeInsets.all(4),
                    )
                ),
              ],
            );
          });

    }

  }

  Widget getBanner() {


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
              currentTime,
              style: TextStyle(
                color: MyColors.gray_999999,
                fontSize: 14,
              ),
            ),
          ),
          Stack(
            children: <Widget>[
              Text(
                currentTemperature+"℃",
                style: TextStyle(
                  color: MyColors.color_DF6565,
                  fontSize: 48,
                ),
              ),
              Align(
                alignment: FractionalOffset.centerRight,
                child: GestureDetector(
                    child:Padding(
                      child:  Image.asset(Utils.getImgPath2("ic_wenduji")),
                      padding: EdgeInsets.fromLTRB(5,3,3,5),
                    ),
                  onTap: setting,
                ),
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
      chartBeans: listData,
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
      scrollEndX: isCaiJing,
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
      key: globalKey,
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



  //下拉菜单
  List<DropdownMenuItem> getListData(){
    List<DropdownMenuItem> items=new List();
    if(devicelist.length==0){
      DropdownMenuItem item=new DropdownMenuItem(
        child:Text(
          "设备连接中...",
          style: TextStyle(
              fontSize: 19,
              color: Color.fromARGB(255, 68, 68, 68)),

        ),
        value: "设备连接中...",
      );
      items.add(item);
    }else{
      devicelist.forEach((it) {
        DropdownMenuItem item=new DropdownMenuItem(
          child:Text(
            it?.name,
            style: TextStyle(
                fontSize: 19,
                color: Color.fromARGB(255, 68, 68, 68)),
          ),
          value: bluetoothDevice?.name,
        );
        items.add(item);
      });
    }
    return items;
  }

  getDropDownMenu(){
    return
        new DropdownButton(
          items: getListData(),
          hint:getTitleView(blueToothName),//当没有默认值的时候可以设置的提示
          //value: value,//下拉菜单选择完之后显示给用户的值
          onChanged: (T){//下拉菜单item点击之后的回调
            setState(() {
              value=T;
            });
          },
          elevation: 24,//设置阴影的高度
          iconSize: 0,//设置三角标icon的大小
          isDense: true,
          //isExpanded:true,
          underline: Container(),
        );
  }

  getTitleView(String name){
    return Container(

      child: Row(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Padding(
            padding: EdgeInsets.only(right: 7),
            child:  ClipOval(
              child: Container(
                width: 7,
                height: 7,
                color: MyColors.color_3464BA,
              ),
            ),
          ),
          Text(
            name,
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
    );

  }

  Timer _timer;
  int count;
  timeStart(){
    isCaiJing=true;
    count=0;
    const period = const Duration(seconds: 2);

    Timer.periodic(period, (timer) async {
      _timer=timer;
      print("timer========");

      if(currentTemperature!="0"){
         setState(() {
          currentTime=Utils.getTime();
          var chartBean=ChartBean(x:Utils.formatXvalue(count),
              y:Utils.formatDouble(currentTemperature),
          millisSeconds: DateTime.now().millisecondsSinceEpoch);
          listData.add(chartBean);

          if(minTemp>double.parse(currentTemperature)){
            minTemp=double.parse(currentTemperature);
          }else if(maxTemp<double.parse(currentTemperature)){
            maxTemp=double.parse(currentTemperature);
          }
          allTem+=double.parse(currentTemperature);
        });
        //currentTemperature="0";
      }
      count++;
    });

  }

  void cancelTimer() {
    if (_timer != null) {
      isCaiJing=false;
      _timer.cancel();
      _timer = null;
    }
  }
  Future<void> initData() async {

    Response response=await HttpUtil.getInstance().get(Api.BANNER);
    if(!mounted){
      return;
    }
    var data=response?.data;
    var list=data["data"];
    List<BannerInfo>listBanner=BannerInfo.fromMapList(list);
    listBanner?.forEach((element){
       _imgData.add(element.url);
    });
    setState(() {

    });
  }

  @override
  bool get wantKeepAlive => true;


  double maxTemp=-1000;
  double minTemp=1000;
  double allTem=0;


  Future<void> _saveData(List<ChartBean>listData) async {
    if(listData==null){
      return;
    }
    var prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    String userId= prefs.getString(ParamName.SP_USER_ID);
    var uuid = Uuid();
    String id=uuid.v1();
    int createTime=listData[0]?.millisSeconds;
    int tempType=tabButton;
    String isUpload="0";
    String deviceId=prefs.getString(ParamName.DEVICE_ID);
    String blueToothId=this.blueToothId;
    String blueToothName=this.blueToothName;
    String tempValueMax=maxTemp.toString();
    String tempValueMin=minTemp.toString();
    String tempValueAverage=(allTem/count).toStringAsFixed(2);
    String detailInfo=jsonEncode(listData);

    int lowValue=prefs.getInt(ParamName.SP_LOW_TEMP)??34;
    int hightValue=prefs.getInt(ParamName.SP_HIGH_TEMP)??40;
    int status=0;
    if(hightValue<maxTemp||lowValue>minTemp){
      status=1;
    }
    var pointInfo=PointInfo();
    pointInfo.id=id;
    pointInfo.createTime=createTime;
    pointInfo.userId=userId??"0";
    pointInfo.tempType=tempType;
    pointInfo.isUpload=isUpload;
    pointInfo.deviceId=deviceId??"0";
    pointInfo.bluetoothId=blueToothId;
    pointInfo.bluetoothName=blueToothName;
    pointInfo.tempValueMax=tempValueMax;
    pointInfo.tempValueMin=tempValueMin;
    pointInfo.tempValueAverage=tempValueAverage;
    pointInfo.detailInfo=detailInfo;
    pointInfo.status=status;
    DatabaseHelper().saveItem(pointInfo);
  }
}
