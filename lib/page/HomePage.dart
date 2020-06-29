import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_qrscaner/flutter_qrscaner.dart';
import 'package:gxq_project/bean/StartEvent.dart';
import 'package:gxq_project/bean/banner_info.dart';
import 'package:gxq_project/bean/point_info.dart';
import 'package:gxq_project/common/api.dart';
import 'package:gxq_project/common/param_name.dart';
import 'package:gxq_project/db/database_helper.dart';
import 'package:gxq_project/http/httpUtil.dart';
import 'package:gxq_project/res/Colors.dart';
import 'package:gxq_project/utils/Toast.dart';
import 'package:gxq_project/utils/Utils.dart';
import 'package:gxq_project/utils/event_bus.dart';
import 'package:gxq_project/widget/CustomRoute.dart';
import 'package:gxq_project/widget/MessageDialog.dart';
import 'package:gxq_project/widget/PopupWindow.dart';
import 'package:gxq_project/widget/banner/widget_banner.dart';
import 'package:gxq_project/widget/line/chart_bean.dart';
import 'package:gxq_project/widget/line/chart_line.dart';
import 'package:popup_window/popup_window.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import 'TemperatureSetPage.dart';
import 'mine/AboutPage.dart';
import 'mine/CommonQuestionPage.dart';
import 'mine/LoginPage.dart';
import 'mine/SetPage.dart';
import 'package:rammus/rammus.dart' as rammus;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  /// 多长时间判定为未连接
  int maxTimeLoss=60*5;
  ///当前温度按钮
  int tabButton = 0;
  double xPosition = 0;
  double yPosition = 0;
  final GlobalKey globalKey = GlobalKey();
  String UUID="0000fff6-0000-1000-8000-00805f9b34fb";

  BluetoothCharacteristic bluetoothCharacteristic;
  BluetoothDevice bluetoothDevice;

  String currentTime="0";
  String currentTemperature="0";
  String temperature="0";

  //设备
  List<BluetoothDevice> devicelist=List();

  List<ChartBean>listData=List();

  bool isCaiJing=false;


  String blueToothId="";
  String blueToothName="设备连接中...";
  //banner
  List<String> _imgData =List<String>();
  List<String> _jumpUrl =List<String>();
  
  
  bool isShowHighTempDialog=false;

  StreamSubscription eventBusOn;

  int connectState=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPush();

    //蓝牙=====================================

    FlutterBlue flutterBlue = FlutterBlue.instance;

    // Start scanning
    flutterBlue.startScan(timeout: Duration(seconds: 60*60));

// Listen to scan results
    flutterBlue.scanResults.listen((results) async {
      // do something with scan results
      for (ScanResult r in results) {
        if(r.device.name!=null&&r.device.name!=""){
          devicelist.add(r.device);
        }

        if(r.device.name.contains("Rdf")&&bluetoothDevice==null){
          bluetoothDevice=r.device;
          print('${r.device.name} found! rssi: ${r.rssi}');
          //flutterBlue.stopScan();
          //await r.device.disconnect();
          await r.device.connect();
          print("已连接======= -=============>");
          blueToothId=r.device.id.id;
          if(r.device.name!=null&&r.device.name!=""){
            setState(() {
              blueToothName=r.device.name;
            });
          }
          r.device.state.listen((s){
            switch(s){
              case BluetoothDeviceState.connected:
                print("蓝牙已经链接=====================");
                setState(() {
                  bluetoothDevice=r.device;
                  blueToothName=bluetoothDevice?.name;
                  connectState=0;
                });
                break;
              case BluetoothDeviceState.disconnected:
                print("蓝牙=========disconnected============");
                setState(() {
                  blueToothName="设备断开连接...";
                  flutterBlue.startScan(timeout: Duration(seconds: 60*60));
                  connectState=2;
                });
                devicelist.remove(bluetoothDevice);
                bluetoothDevice=null;

                break;
              case BluetoothDeviceState.connecting:
                print("蓝牙=========connecting============");
                setState(() {
                  connectState=0;
                });
                break;
              case BluetoothDeviceState.disconnecting:
                setState(() {
                  connectState=2;
                });

                print("蓝牙======disconnecting===============");
                break;
            }
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
              temperature=Utils.getTemperature(value);
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

    if(isShowHighTempDialog){
      showHighTempDialog();
    }

    eventBusOn=eventBus.on<StartEvent>().listen((event){
        if(!event.isCaijing){
          timeStart();
        }else{
          cancelTimer();
        }
    });
    Future.delayed(Duration.zero, () {
      showYinsiDialog();
    });
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
                            child: getTitleView(blueToothName),
                          )),
                      Container(
                        child: Container(
                          width: 50,
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
                          if(isCaiJing){
                            Toast.toast(context,msg: "温度正在采集");
                            return;
                          }
                          setState(() {
                            tabButton = 0;
                          });
                        }, 0),
                      ),
                      Expanded(
                        flex: 1,
                        child: getTabButton("室温", () {
                          if(isCaiJing){
                            Toast.toast(context,msg: "温度正在采集");
                            return;
                          }
                          setState(() {
                            tabButton = 1;
                          });
                        }, 1),
                      ),
                      Expanded(
                        flex: 1,
                        child: getTabButton("水温", () {
                          if(isCaiJing){
                            Toast.toast(context,msg: "温度正在采集");
                            return;
                          }
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
  Future<void> setting() async {
    var prefs = await SharedPreferences.getInstance();
    bool isLogin=prefs.getBool(ParamName.IS_LOGIN)??false;
    if(!isLogin){
      Navigator.push(context, CustomRoute(LoginPage()));
      return;
    }
    Navigator.push(context, CustomRoute(TemperatureSetPage(isCaiJIng:isCaiJing,index: tabButton,)));
//    if(!isCaiJing){
//      var prefs = await SharedPreferences.getInstance();
//      bool isLogin=prefs.getBool(ParamName.IS_LOGIN)??false;
//      if(!isLogin){
//        Navigator.push(context, CustomRoute(LoginPage()));
//        return;
//      }
//      showDialog(
//          context: context,
//          barrierDismissible: true,
//          builder: (BuildContext context) {
//            return AlertDialog(
//              content: Text('开始采集'),
//              actions: <Widget>[
//                FlatButton(
//                    onPressed: () {
//                      timeStart();
//                      Navigator.of(context).pop();
//                    },
//                    child: Padding(
//                    child: Text('确认'),
//            padding: EdgeInsets.fromLTRB(5,3,3,5),
//            )),
//                FlatButton(
//                    onPressed: () {
//                      Navigator.of(context).pop();
//                    },
//                    child: Padding(
//                        child: Text('取消'),
//                        padding: EdgeInsets.fromLTRB(5,3,3,5),
//                    )),
//              ],
//            );
//          });
//    }else{
//      showDialog(
//          context: context,
//          barrierDismissible: true,
//          builder: (BuildContext context) {
//            return AlertDialog(
//              content: Text('结束采集'),
//              actions: <Widget>[
//                FlatButton(
//                    onPressed: () {
//                      Navigator.of(context).pop();
//                      cancelTimer();
//                      setState(() {
//
//                      });
//                      _saveData(listData);
//                    },
//                    child: Padding(
//                      child: Text('确定'),
//                      padding: EdgeInsets.all(4),
//                    )
//                ),
//                FlatButton(
//                    onPressed: () {
//                      Navigator.of(context).pop();
//                    },
//                    child:Padding(
//                      child:  Text('取消'),
//                      padding: EdgeInsets.all(4),
//                    )
//                ),
//              ],
//            );
//          });

//    }

  }

  Widget getBanner() {
    return CustomBanner(_imgData,_jumpUrl);
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
    MaterialColor myColor=null;
    if(connectState==0){
      myColor=Colors.orange;
    }else if(connectState==1){
      myColor=Colors.blue;
    }else if(connectState==2){
      myColor=Colors.grey;
    }
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
                child: RaisedButton(
                  child: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        "温度计",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12
                        ),
                      )
                  ),
                  color:  myColor,
                  onPressed: setting,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)), //圆角大小
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
      isShowFloat:true,
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

  getTitleView(String name){
    return Container(

      child: GestureDetector(
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          key: popBottomKey,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(),
            ),
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
            Expanded(
              flex: 1,
              child: Container(),
            ),
          ],
        ),
        onTap: showPop,
      ),
    );
  }
  GlobalKey popBottomKey= GlobalKey();

  showPop(){
    PopupWindow.showPopWindow(context, "bottom",
        popBottomKey, PopDirection.bottom, getPopWindowList(), 0);
  }

  Widget getPopWindowList(){
    if(devicelist.length==0){
      return Container(
        color: MyColors.color_bg_pop,
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Text(
          "设备连接中...",
          style: TextStyle(
              fontSize: 19,
              color: Color.fromARGB(255, 68, 68, 68)),
        ),
      );
    }else{
      return Container(
        color: Colors.white,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return GestureDetector(
                child: Text(
                  devicelist[index].name,
                  style: TextStyle(
                      fontSize: 19,
                      color: Color.fromARGB(255, 68, 68, 68)),
                ),
                onTap:(){
                  // var ss=devicelist[index].name;
                }
            );
          },
          itemCount: devicelist.length,
        ),
      );
    }

  }




  Timer _timer;
  int count=0;
  timeStart() async {
    if(isCaiJing){
      return;
    }
    isCaiJing=true;
    const period = const Duration(seconds: 2);
    listData.clear();
    count=0;
    unConnectCount=0;

    var prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    if(tabButton==0)
       setMinTemp=prefs.getDouble(ParamName.SP_LOW_TEMP_PEOPLE)??35;
       setMaxTemp=prefs.getDouble(ParamName.SP_HIGH_TEMP_PEOPLE)??39;
    if(tabButton==1){
      setMinTemp=prefs.getDouble(ParamName.SP_LOW_TEMP_ROOM)??15;
      setMaxTemp=prefs.getDouble(ParamName.SP_HIGH_TEMP_ROOM)??36;
    }else if(tabButton==2){
      setMinTemp=prefs.getDouble(ParamName.SP_LOW_TEMP_WATER)??20;
      setMaxTemp=prefs.getDouble(ParamName.SP_HIGH_TEMP_WATER)??45;
    }
    runnable();
    Timer.periodic(period, (timer) async {
      _timer=timer;
      print("timer========");
      runnable();

    });
    setState(() {
      connectState=1;
    });
  }
  int unConnectCount=0;
  runnable(){
    if(temperature!="0"){
      unConnectCount=0;
      setState(() {
        currentTime=Utils.getTime();
        currentTemperature=temperature;
        temperature="0";
        var chartBean=ChartBean(x:Utils.formatXvalue(count),
            y:Utils.formatDouble(currentTemperature),
            millisSeconds: DateTime.now().millisecondsSinceEpoch);
        listData.add(chartBean);

        if(count==0){
          minTemp=double.parse(currentTemperature);
          maxTemp=double.parse(currentTemperature);
        }
        if(minTemp>double.parse(currentTemperature)){
          minTemp=double.parse(currentTemperature);
        }else if(maxTemp<double.parse(currentTemperature)){
          maxTemp=double.parse(currentTemperature);
        }
        allTem+=double.parse(currentTemperature);
        count++;
        if(double.parse(currentTemperature)>setMaxTemp
            ||double.parse(currentTemperature)<setMinTemp){

          if(!isShowHighTempDialog){
            showHighTempDialog();
          }
          //cancelTimer();
        }
      });
    }else{
      unConnectCount++;
      if(isLoss()){
        cancelTimer();
        connectState=2;
        showLossDialog();
      }
    }
  }

  bool isLoss(){
    return unConnectCount>maxTimeLoss;
  }

  void cancelTimer() {
    if (_timer != null) {
      isCaiJing=false;
      _timer.cancel();
      _timer = null;
      connectState=0;
      _saveData(listData);
    }
    setState(() {

    });

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
       _jumpUrl.add(element.jumpUrl);
    });
    setState(() {

    });
  }

  @override
  bool get wantKeepAlive => true;


  double maxTemp=0;
  double minTemp=0;
  double allTem=0;
 // int currentstatus=-1;

  double setMaxTemp;
  double setMinTemp;

  Future<void> _saveData(List<ChartBean>listData) async {
    if(listData==null||listData.length==0){
      return;
    }
    var prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    int userId= prefs.getInt(ParamName.SP_USER_ID)??0;
    var uuid = Uuid();
    String id=uuid.v1();
    int createTime=listData[0]?.millisSeconds;
    int tempType=tabButton;
    String isUpload="0";
    String deviceId=await rammus.deviceId;
    String blueToothId=this.blueToothId;
    String blueToothName=this.bluetoothDevice?.name;
    String tempValueMax=maxTemp.toString();
    String tempValueMin=minTemp.toString();
    String tempValueAverage=(allTem/listData.length).toStringAsFixed(2);
    String detailInfo=jsonEncode(listData);

    double lowValue=prefs.getDouble(ParamName.SP_LOW_TEMP_PEOPLE)??35;
    double hightValue=prefs.getDouble(ParamName.SP_HIGH_TEMP_PEOPLE)??39;
    if(tempType==1){
      lowValue=prefs.getDouble(ParamName.SP_LOW_TEMP_ROOM)??15;
      hightValue=prefs.getDouble(ParamName.SP_HIGH_TEMP_ROOM)??36;
    }else if(tempType==2){
      lowValue=prefs.getDouble(ParamName.SP_LOW_TEMP_WATER)??20;
      hightValue=prefs.getDouble(ParamName.SP_HIGH_TEMP_WATER)??45;
    }
    int status=0;
    // ignore: unrelated_type_equality_checks

    if(double.parse(currentTemperature)>setMaxTemp
        ||double.parse(currentTemperature)<setMinTemp){
      status=1;
    }else if(isLoss()){
      status=2;
    }
    var pointInfo=PointInfo();
    pointInfo.id=id;
    pointInfo.createTime=createTime;
    pointInfo.userId=userId.toString();
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

    Response response= await HttpUtil.getInstance().post(Api.upload_one,data: pointInfo.toMap());
    var data=response?.data;
    if(data['code']==200){
      pointInfo.isUpload="1";
      //存库
      DatabaseHelper().updateItem(pointInfo);
    }


    maxTemp=-1000;
    minTemp=1000;
    allTem=0;
  //  currentstatus=-1;
  }


  initPush() async {
//    var channels = List<rammus.NotificationChannel>();
//    channels.add(rammus.NotificationChannel(
//      "1",
//      "rammus",
//      "rammus test",
//      importance: rammus.AndroidNotificationImportance.MAX,
//    ));
//    //推送通知的处理 (注意，这里的id:针对Android8.0以上的设备来设置通知通道,客户端的id跟阿里云的通知通道要一致，否则收不到通知)
//    rammus.setupNotificationManager(channels);
    rammus.setupNotificationManager(id: "1",name: "rammus",description: "rammus test",);

    rammus.onNotification.listen((data){
      Toast.toast(context,msg:data.toString()+"onNotification");
      print("-==================================================>notification here ${data.summary}");
    });
    rammus.onNotificationOpened.listen((data){//这里是点击通知栏回调的方法
      print("-=============================================================> ${data.summary} 被点了");
      isShowHighTempDialog=true;
      showHighTempDialog();
      Toast.toast(context,msg:data.toString()+"onNotificationOpened");
    });

    rammus.onNotificationRemoved.listen((data){
      print("-==================> $data 被删除了");
    });

    rammus.onNotificationReceivedInApp.listen((data){
      print("-ReceivedInApp==============================================================>${data.summary} In app");
    });

    rammus.onNotificationClickedWithNoAction.listen((data){
      print("${data.summary} no action-==============================================================>");
    });

    rammus.onMessageArrived.listen((data){
      print("received data -===============================================================> ${data.content}");
    });

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

  showHighTempDialog(){
    isShowHighTempDialog=true;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return GestureDetector(
            child: Image.asset(Utils.getImgPath2("ic_push_dialog_bg")),
            onTap: (){
              Navigator.of(context).pop();
              isShowHighTempDialog=false;
            },
          );
        });
  }

  void showLossDialog(){
          showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('采集温度异常，设备已经断开'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
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

  void showYinsiDialog(){

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
//            content: Text('我们非常重视您的隐私和个人信息保护，请您认真阅读'
//            '《用户协议》和《隐私政策》，您同意并接受全部条款后方可使用爱启航HD相关功能。'),
          content:RichText(
              text:TextSpan(
                text: '我们非常重视您的隐私和个人信息保护，请您认真阅读',
                style: TextStyle(color: Colors.black,fontSize: 16.0),
                  children: <TextSpan>[
                    TextSpan(
                    text: '《用户协议》',
                    style: TextStyle(color: MyColors.color_3ECCC7,fontSize: 16.0),
                    recognizer: TapGestureRecognizer()..onTap = () async {
                      await launch(ParamName.URL_YINSI);
                    }),
                    TextSpan(
                        text: '，您同意并接受全部条款后方可使用相关功能。',
                        style: TextStyle(color: Colors.black,fontSize: 16.0),
                        recognizer: TapGestureRecognizer()..onTap = () async {
                          await launch(ParamName.URL_YINSI);
                        }),
                  ]
              )
          ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    child: Text('同意并继续'),
                    padding: EdgeInsets.all(4),
                  )
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:Padding(
                    child:  Text('暂不同意'),
                    padding: EdgeInsets.all(4),
                  )
              ),
            ],
          );
        });
  }
}
