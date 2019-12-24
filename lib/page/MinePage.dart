import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gxq_project/utils/Utils.dart';

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
            margin:  EdgeInsets.fromLTRB(10,50,0,0),
            child: Column(
              children: <Widget>[
                Row(children: <Widget>[
                  CircleAvatar(
                    radius: 36.0,
                    backgroundImage: AssetImage(Utils.getImgPath2("ic_avatar")),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
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
                                  color: Color.fromARGB(100, 178, 178, 178)
                              ),
                            )
                        ),
                      ],
                    )
                  ),
                ],)
                ,
                SizedBox(height: 30.0),
                getText("设备管理"),
                Divider(height: 1.0,color: Colors.blueGrey),
                getText("提醒设置"),
                Divider(height: 1.0,color: Colors.blueGrey),
                getText("服务条款"),
                Divider(height: 1.0,color: Colors.blueGrey),
                getText("意见反馈"),
                Divider(height: 1.0,color: Colors.blueGrey),
                getText("关于我们"),
                Divider(height: 1.0,color: Colors.blueGrey),
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
                      child: Text("登录"),
                    ),
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                  ),
                )


              ],
            ),
          ),
      ),


    );
  }
  Container getText(String text){
    return Container(
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
    );
  }



}