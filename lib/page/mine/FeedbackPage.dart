import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gxq_project/common/api.dart';
import 'package:gxq_project/http/httpUtil.dart';
import 'package:gxq_project/res/Colors.dart';
import 'package:gxq_project/utils/Toast.dart';
import 'package:gxq_project/utils/Utils.dart';
import 'package:loading_dialog/loading_dialog.dart';

class FeedbackPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FeedbackPageState();
  }

}

class FeedbackPageState extends State<FeedbackPage>{
  String text="";
  LoadingDialog loading ;
  @override
  Widget build(BuildContext context) {

    final controller = TextEditingController();
    controller.addListener(() {
//      if(text.isEmpty&&controller.text.isNotEmpty){
//        setState(() {
//
//        });
//      }
      text=controller.text;

    });
    loading= LoadingDialog(buildContext: context);
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment : CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.fromLTRB(20, 30, 0, 0),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      child: Image.asset(Utils.getImgPath2("ic_back")),
                      onTap: (){
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Row(
                children: <Widget>[
                  Text(
                    "意见反馈",
                    style: TextStyle(
                        fontSize: 28,
                        color: Color.fromARGB(255, 0, 0, 0)
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 10,
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              color: Color.fromARGB(255, 238, 238, 238),
            ),
            buildTextField(controller),
            Container(
              margin: EdgeInsets.fromLTRB(20, 60, 20, 0),
              child: FlatButton(

                onPressed: () async {
                  if(text.isEmpty){
                    Toast.toast(context,msg: "请输入内容");
                    return;
                  }
                  loading?.show();
                  Response response=await HttpUtil.getInstance()
                      .post(Api.yijianfankui,data: {"remark":text});
                  if (!mounted) return;
                  loading?.hide();
                  Toast.toast(context,msg: "提交成功");
                  Navigator.pop(context);
                },
                child: Container(
                  margin:  EdgeInsets.fromLTRB(20,0,20,0),
                  height: 50,
                  alignment: const Alignment(0,0),
                  child: Text(
                    "提交",
                    style: TextStyle(
                        fontSize: 16,
                        color: MyColors.color_888888
                    ),
                  ),
                ),
                color: MyColors.color_00286B,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  side: BorderSide(
                    color: Color.fromARGB(255, 211, 211, 211),
                    width: 1,
                  ),
                ),
              ),
            )

          ],
        ),
      )
    );
  }

  Widget buildTextField(TextEditingController controller) {
    return Container(
      height: 150,
      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: new BoxDecoration(
       // border: new Border.all(width: 1.0, color: MyColors.color_divider),
        color: MyColors.color_f8f8f9,
        borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
      ),
      //color: MyColors.color_f8f8f9,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: TextField(
          controller: controller,
          autocorrect: true,//是否自动更正
          autofocus: true,//是否自动对焦
          textAlign: TextAlign.left,//文本对齐方式
          cursorColor: Colors.grey,
          maxLength: 140,
          maxLines:9,
          cursorWidth: 1.0,
          style: TextStyle(fontSize: 14.0, color: MyColors.color_444444),//输入文本的样式
          onChanged: (text) {//内容改变的回调
            print('change $text');
          },
          onSubmitted: (text) {//内容提交(按回车)的回调
            print('submit $text');
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 0.0),

            border: InputBorder.none,
            hintText: '请您发送，您的宝贵意见，我们一定虚心接受，用心改正，为您提供更加优质的服务…',
            hintStyle:TextStyle(color: MyColors.color_888888,fontSize: 14),
            filled: true,
            fillColor: MyColors.color_f8f8f9,
          ),
        ),
      ),
    );
  }

}