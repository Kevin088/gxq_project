import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gxq_project/bean/point_info.dart';
import 'package:gxq_project/common/api.dart';
import 'package:gxq_project/common/param_name.dart';
import 'package:gxq_project/db/database_helper.dart';
import 'package:gxq_project/http/httpUtil.dart';
import 'package:gxq_project/page/HomePage.dart';
import 'package:gxq_project/page/MinePage.dart';
import 'package:gxq_project/page/SecondPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavigationWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new BottomNavigationWidgetState();
  }
}

class BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _currentIndex = 0;
  List<Widget> pages = new List();

  @override
  void initState() {
    // TODO: implement initState
    pages
      ..add(HomePage())
      ..add(SecondPage())
        ..add(MinePage());
    initData();
  }
  Future<void> initData() async {
    //下载
    var prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    String deviceId=prefs.getString(ParamName.DEVICE_ID);
    Response response= await HttpUtil.getInstance().post(Api.getList+deviceId);
    var data=response?.data;
    var list=data['data'];
    if(list!=null){
      List<PointInfo> listInfo=PointInfo.fromMapList(list);
      if(listInfo!=null){
        listInfo.forEach((bean){
          bean.isUpload="1";
        });
        //存库
       await DatabaseHelper().insertList(listInfo);
      }
    }


    //上传
    DatabaseHelper().getUnuploadList().then((value)  {
      if(value.length>0){
        HttpUtil.getInstance().post(Api.upload,data: value);
      }
    });
  }
  var _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    /*
    返回一个脚手架，里面包含两个属性，一个是底部导航栏，另一个就是主体内容
     */
    return new Scaffold(
      body: PageView.builder(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: _pageChanged,
          itemCount: pages.length,
          itemBuilder: (context, index) => pages[index]),
      bottomNavigationBar: BottomNavigationBar(
        //底部导航栏的创建需要对应的功能标签作为子项，这里我就写了3个，每个子项包含一个图标和一个title。
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              title: new Text(
                '首页',
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.business,
              ),
              title: new Text(
                '商业',
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.mood,
              ),
              title: new Text(
                '我的',
              )),
        ],
        //这是底部导航栏自带的位标属性，表示底部导航栏当前处于哪个导航标签。给他一个初始值0，也就是默认第一个标签页面。
        currentIndex: _currentIndex,
        //这是点击属性，会执行带有一个int值的回调函数，这个int值是系统自动返回的你点击的那个标签的位标
        onTap: onTabTapped,
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  void _pageChanged(int index) {
    setState(() {
      if (_currentIndex != index) _currentIndex = index;
    });
  }

  void onTabTapped(int index) {
    _pageController.jumpToPage(index);
  }
}

