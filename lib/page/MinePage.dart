import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gxq_project/page/mine/MineInfoPage.dart';
import 'package:gxq_project/utils/Utils.dart';
import 'package:gxq_project/widget/CustomRoute.dart';

class MinePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MinePageState();
  }

}

class MinePageState extends State<MinePage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      home:Scaffold(
//        appBar: AppBar(
//          title: Text("我的"),
//          backgroundColor: Color.fromARGB(255, 199, 136, 213),
//          centerTitle: true,
//        ),
          body: Container(
            margin:  EdgeInsets.fromLTRB(10,50,10,0),
            child: Column(
              children: <Widget>[
                Row(children: <Widget>[
                  CircleAvatar(
                    radius: 36.0,
                    backgroundImage: AssetImage(Utils.getImgPath2("ic_avatar")),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "比格",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child:
                            Text(
                              "电话号码：15313729066",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Color.fromARGB(255, 178, 178, 178)
                              ),
                            )
                        ),
                      ],
                    )
                  ),
                ],)
                ,
                SizedBox(height: 30.0),
                getText("设备管理",
                    (){
                      Navigator.push(context, CustomRoute(MineInfoPage()));
                    }),
                Divider(height: 1.0,color: Color.fromARGB(255, 220, 220, 220)),
                getText("提醒设置",null),
                Divider(height: 1.0,color: Color.fromARGB(255, 220, 220, 220)),
                getText("服务条款",null),
                Divider(height: 1.0,color: Color.fromARGB(255, 220, 220, 220)),
                getText("意见反馈",null),
                Divider(height: 1.0,color: Color.fromARGB(255, 220, 220, 220)),
                getText("关于我们",null),
                Divider(height: 1.0,color: Color.fromARGB(255, 220, 220, 220)),
                Expanded(child: Container()),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: FlatButton(

                    onPressed: (){
                      print(1);
                    },
                    child: Container(
                      margin:  EdgeInsets.fromLTRB(20,0,20,0),
                      height: 40,
                      alignment: const Alignment(0,0),
                      child: Text(
                          "退出登录",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 136, 136, 136)
                        ),
                      ),
                    ),
                    color: Colors.white,

                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        side: BorderSide(
                            color: Color.fromARGB(255, 211, 211, 211),
                          width: 1,
                        ),
                    ),
                  ),
                )
              ],
            ),
          ),
      ),


    );
  }
  GestureDetector getText(String text,Function callBack){
    return GestureDetector(
      onTap: callBack,
      child: Container(
        padding: EdgeInsets.fromLTRB(10,0,10,0),
        height: 50.0,
        child: Row(

          children: <Widget>[
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            )
            ,
            Image(
              image: AssetImage(Utils.getImgPath2("ic_arraw")),
            )

          ],
        ),
      ),
    );

  }



}