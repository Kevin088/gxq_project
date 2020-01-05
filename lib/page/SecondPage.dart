import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gxq_project/page/TemperatureDetailPage.dart';
import 'package:gxq_project/res/Colors.dart';
import 'package:gxq_project/res/style.dart';
import 'package:gxq_project/utils/Utils.dart';
import 'package:gxq_project/widget/CustomRoute.dart';

class SecondPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SecondPageState();
  }
}

class SecondPageState extends State<SecondPage> {
  List<String> _list = List.generate(10, (i) => '原始数据${i + 1}');
  bool isLoading = false;

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

  Widget getListView() {
    return Expanded(
        child: NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollNotification) {
        if (scrollNotification.metrics.pixels >=
            scrollNotification.metrics.maxScrollExtent) {
          _loadMore();
        }
        return false;
      },
      child: RefreshIndicator(
        child: ListView.builder(
          itemBuilder: (context, index) {
            if (index < _list.length) {
              return getItemView(index);
            } else {
              // 最后一项，显示加载更多布局
              return _buildLoadMoreItem();
            }
          },
          itemCount: _list.length + 1,
        ),
        onRefresh: _handleRefresh,
      ),
    ));
  }

  Widget getListView1() {
    return Expanded(
        child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
              itemBuilder: (context, index) {
                if (index < _list.length) {
                  return getItemView(index);
                } else {
                  // 最后一项，显示加载更多布局
                  return _buildLoadMoreItem();
                }
              },
              itemCount: _list.length,
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
  Future<Null> _handleRefresh() async {
    // 模拟数据的延迟加载
    await Future.delayed(Duration(seconds: 2), () {
      setState(() {
        // 在列表开头添加几条数据
        List<String> _refreshData = List.generate(5, (i) => '下拉刷新数据${i + 1}');
        _list.insertAll(0, _refreshData);
      });
    });
  }

  // 上拉加载
  Future<Null> _loadMore() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      // 模拟数据的延迟加载
      await Future.delayed(Duration(seconds: 2), () {
        setState(() {
          isLoading = false;
          List<String> _loadMoreData =
              List.generate(5, (i) => '上拉加载数据${i + 1}');
          _list.addAll(_loadMoreData);
        });
      });
    }
  }

  Widget getItemView(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, CustomRoute(TemperatureDetailPage()));
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 0.5, color: MyColors.color_divider))),
        height: 80,
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Row(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "体温正常",
                  style: TextStyle(
                      color: MyColors.color_444444,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(
                  "2019/12/31 13:00:00",
                  style: TextStyle(
                    color: MyColors.gray_999999,
                    fontSize: 12,
                  ),
                ),
                Text(
                  "KHO温度",
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
              "37.5",
              style: TextStyle(color: MyColors.color_3464BA, fontSize: 20),
            ),
            Container(
              width: 8,
            ),
            ClipOval(
              child: Container(
                height: 6,
                width: 6,
                color: MyColors.color_3464BA,
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
    );
  }
}
