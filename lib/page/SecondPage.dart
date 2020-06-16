import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gxq_project/bean/point_info.dart';
import 'package:gxq_project/common/api.dart';
import 'package:gxq_project/db/database_helper.dart';
import 'package:gxq_project/http/httpUtil.dart';
import 'package:gxq_project/page/TemperatureDetailPage.dart';
import 'package:gxq_project/res/Colors.dart';
import 'package:gxq_project/res/style.dart';
import 'package:gxq_project/utils/Toast.dart';
import 'package:gxq_project/utils/Utils.dart';
import 'package:gxq_project/widget/CustomRoute.dart';
import 'package:gxq_project/widget/SlideButton.dart';
import 'package:loading_dialog/loading_dialog.dart';

class SecondPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SecondPageState();
  }
}

class SecondPageState extends State<SecondPage> {


  var mList=List<PointInfo>();
  bool isLoading = false;

  LoadingDialog loading ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();

    loading=new LoadingDialog(buildContext: context);
  }

  void initData(){
    DatabaseHelper().getTotalList().then((value){
      mList.clear();
      mList.addAll(PointInfo.fromMapList(value));
       setState(() {

       });

    });




  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
              child: Text(
                "体温记录",
                style: TextStyles.text_22_444444,
              ),
            ),
            getView1(),
            Divider(height: 40.0, color: MyColors.color_divider),
            getListView1(),
          ],
        ),
      ),
    );
  }

  Widget getView1() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 35, 20, 0),
      child: Row(
        children: <Widget>[
          Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Container(
                  width: 18,
                  height: 6,
                  color: MyColors.color_3464BA,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(6, 0, 0, 0),
                child: Text(
                  "正常",
                  style: TextStyle(
                    color: MyColors.color_444444,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(27, 0, 0, 0),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Container(
                    width: 18,
                    height: 6,
                    color: MyColors.color_DFC865,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(6, 0, 0, 0),
                  child: Text(
                    "中断",
                    style: TextStyle(
                      color: MyColors.color_444444,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(27, 0, 0, 0),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Container(
                    width: 18,
                    height: 6,
                    color: MyColors.color_DF6565,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(6, 0, 0, 0),
                  child: Text(
                    "报警",
                    style: TextStyle(
                      color: MyColors.color_444444,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

//  Widget getListView() {
//    return Expanded(
//        child: NotificationListener<ScrollNotification>(
//      onNotification: (ScrollNotification scrollNotification) {
//        if (scrollNotification.metrics.pixels >=
//            scrollNotification.metrics.maxScrollExtent) {
//          //_loadMore();
//        }
//        return false;
//      },
//      child: RefreshIndicator(
//        child: ListView.builder(
//          itemBuilder: (context, index) {
//            if (index < mList.length) {
//              return getItemView(index);
//            } else {
//              // 最后一项，显示加载更多布局
//              return _buildLoadMoreItem();
//            }
//          },
//          itemCount: mList.length + 1,
//        ),
//        //onRefresh: _handleRefresh,
//      ),
//    ));
//  }

  Widget getListView1() {
    return Expanded(
        child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return getItemView(index);
              },
              itemCount: mList.length,
            )));
  }

  // 加载更多布局
  Widget _buildLoadMoreItem() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text("加载中..."),
      ),
    );
  }

  // 下拉刷新方法
//  Future<Null> _handleRefresh() async {
//    // 模拟数据的延迟加载
//    await Future.delayed(Duration(seconds: 2), () {
//      setState(() {
//        // 在列表开头添加几条数据
//        List<String> _refreshData = List.generate(5, (i) => '下拉刷新数据${i + 1}');
//        _list.insertAll(0, _refreshData);
//      });
//    });
//  }

  // 上拉加载
//  Future<Null> _loadMore() async {
//    if (!isLoading) {
//      setState(() {
//        isLoading = true;
//      });
//      // 模拟数据的延迟加载
//      await Future.delayed(Duration(seconds: 2), () {
//        setState(() {
//          isLoading = false;
//          List<String> _loadMoreData =
//              List.generate(5, (i) => '上拉加载数据${i + 1}');
//          _list.addAll(_loadMoreData);
//        });
//      });
//    }
//  }
  var list=List<SlideButton>();
  SlideButton getItemView(int index) {
    var pointInfo=mList[index];
    var title;
    var temp;
    if(pointInfo.status==0){
      title="体温正常";
      temp=pointInfo.tempValueAverage;
    } else if(pointInfo.status==2){
      title="体温中断";
      temp=pointInfo.tempValueAverage;
    }else if(pointInfo.status==1){
      title="体温报警";
      temp=pointInfo.tempValueMax;
    }
    var key = GlobalKey<SlideButtonState>();
    var slide = SlideButton(
      key:key,
      singleButtonWidth: 80,
      onSlideStarted: (){
        list.forEach((slide){
          if(slide.key!=key){
            slide.key.currentState?.close();
          }
        });
      },
      //滑动开显示的button
      buttons: <Widget>[
        buildAction1(key, "删 除", MyColors.color_DF6565, () {
         //Toast.toast(context,msg: index.toString());
         delInfo(mList[index].id);
          key.currentState.close();
        }),
      ],
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, CustomRoute(TemperatureDetailPage(pointInfo: pointInfo)));
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(width: 0.5, color: MyColors.color_divider))),
          height: 80,
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                        color: MyColors.color_444444,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    Utils.formatTime(pointInfo.createTime),
                    style: TextStyle(
                      color: MyColors.gray_999999,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    pointInfo.bluetoothName,
                    style: TextStyle(
                      color: MyColors.gray_999999,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(),
              ),
              Text(
                temp,
                style: TextStyle(color: Utils.getColor(pointInfo.status), fontSize: 20),
              ),
              Container(
                width: 8,
              ),
              ClipOval(
                child: Container(
                  height: 6,
                  width: 6,
                  color: Utils.getColor(pointInfo.status),
                ),
              ),
              Container(
                width: 8,
              ),
              Image(
                image: AssetImage(Utils.getImgPath2("ic_arraw")),
              )
            ],
          ),
        ),
      ),

    );
    list.add(slide);

    return slide;
  }
  //构建button
  InkWell buildAction1(GlobalKey<SlideButtonState> key, String text, Color color,
      GestureTapCallback tap) {

    return InkWell(
      onTap: tap,
      child: Container(
        decoration:BoxDecoration(
          borderRadius: new BorderRadius.only(topRight: new Radius.circular(10.0),bottomRight: new Radius.circular(10.0)),
          color: color,
        ),
        alignment: Alignment.center,
        width: 80,
        height: 92,
        child: Text(text,
            style: TextStyle(
              color: Colors.white,
            )),
      ),
    );
  }

  delInfo(String id) async {
    if(id.isEmpty){
      return;
    }
    loading.show();
    Response response=await HttpUtil.getInstance().post(Api.del+id,);
    if (!mounted) return;
    loading.hide();
    var loginInfo=response?.data;
    var code=loginInfo['code'];
    Toast.toast(context,msg: code==200?"成功":"失败");
    if(code!=200){
      return;
    }

    DatabaseHelper().deleteItem(id).then((value){

      initData();

    });
  }
}
