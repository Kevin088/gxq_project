import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gxq_project/res/Colors.dart';
import 'package:gxq_project/utils/Utils.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

class ProtocolPage extends StatefulWidget{
  String content="【首部及导言】 欢迎您使用腾讯的服务！ 为使用腾讯的服务，您应当阅读并遵守《腾讯服务协议》（以下简称“本协议”）和《腾讯隐私政策》。请您务必审慎阅读、充分理解各条款内容，特别是免除或者限制腾讯责任的条款、对用户权利进行限制的条款、约定争议解决方式和司法管辖的条款（如第十八条相关约定）等，以及开通或使用某项服务的单独协议或规则。限制、免责条款或者其他涉及您重大权益的条款可能以加粗、加下划线等形式提示您重点注意。 除非您已充分阅读、完全理解并接受本协议所有条款，否则您无权使用腾讯服务。您点击“同意”或“下一步”，或您使用腾讯服务，或者以其他任何明示或者默示方式表示接受本协议的，均视为您已阅读并同意签署本协议。本协议即在您与腾讯之间产生法律效力，成为对双方均具有约束力的法律文件。 如果您因年龄、智力等因素而不具有完全民事行为能力，请在法定监护人（以下简称\"监护人\"）的陪同下阅读和判断是否同意本协议，并特别注意未成年人使用条款。 如果您是中国大陆地区以外的用户，您订立或履行本协议还需要同时遵守您所属和/或所处国家或地区的法律。 一、【协议的范围】 您已充分阅读、完全理解并接受本协议所有条款，否则您无权使用腾讯服务。您点击“同意”或“下一步”，或您使用腾讯服务，或者以其他任何明示或者默示方式表示接受本协议的，均视为您已阅读并同意签署本协议。本协议即在您与腾讯之间产生法律效力，成为对双方均具有约束力的法律文件。 如果您因年龄、智力等因素而不具有完全民事行为能力，请在法定监护人（以下简称\"监护人\"）的陪同下阅读和判断是否同意本协议，并特别注意未成年人使用条款。 如果您是中国大陆地区以外的用户，您订立或履行本协议还需要同时遵守您所属和或所处国家或地区的法律。";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProtocolPageState();
  }

}

class ProtocolPageState extends State<ProtocolPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment : CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(20, 30, 0, 0),
              child: GestureDetector(
                child: Image.asset(Utils.getImgPath2("ic_back")),
                onTap: (){
                  Navigator.pop(context);
                },
              ),
            ),

            Container(
                margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: Center(
                  child: Text(
                    "企业服务条款",
                    style: TextStyle(
                        fontSize: 28,
                        color: Color.fromARGB(255, 0, 0, 0)
                    ),
                  ),
                )
            ),
            SingleChildScrollView(
              child: Container(
                  margin: EdgeInsets.fromLTRB(20, 50, 20, 0),

                  child:Text(
                      widget.content
                  )
              ),

            ),



          ],
        ),
      )
    );
  }

}