import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gxq_project/utils/Utils.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

class MineInfoPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MineInfoPageState();
  }

}

class MineInfoPageState extends State<MineInfoPage>{
  File _image;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
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
            child: Text(
              "个人信息设置",
              style: TextStyle(
                  fontSize: 28,
                  color: Color.fromARGB(255, 0, 0, 0)
              ),
            ),
          ),
          Container(
            height: 10,
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            color: Color.fromARGB(255, 238, 238, 238),
          ),
          Container(
            height: 61,
            child:Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20,0,0,0),
                  child: Text(
                    "头像",
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 0, 0, 0)
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child:Container(
                    alignment: const Alignment(1, 0),
                    child: FlatButton(
                      onPressed: getImage,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: _image==null?Image.asset(Utils.getImgPath2("ic_avatar"),width: 40,height: 40,):Image.file(_image,fit:  BoxFit.cover,width: 40,height: 40,),

                        ),

//                      child:CircleAvatar(
//                        radius: 18.0,
//                        backgroundImage:_image==null?AssetImage(Utils.getImgPath2("ic_avatar")):Image.file(_image),
//                      ),
                    ),
                  )
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(0,0,20, 0),
                  child: Image(
                    image: AssetImage(Utils.getImgPath2("ic_arraw")),
                  ),
                )

              ],
            ),
          ),
          Divider(height: 1.0,color: Color.fromARGB(255, 220, 220, 220)),
          Container(
            height: 61,
            child:Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20,0,0,0),
                  child: Text(
                    "昵称",
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 0, 0, 0)
                    ),
                  ),
                ),
                Expanded(
                    child:Container(
                      alignment: const Alignment(1, 0),
                      child: FlatButton(
                        onPressed: getImage,
                        child:Text(
                            "末世狐狸",
                            style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 68, 68, 68)
                              
                            ),
                        ),
                      ),
                    )
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(0,0,20, 0),
                  child: Image(
                    image: AssetImage(Utils.getImgPath2("ic_arraw")),
                  ),
                )

              ],
            ),
          ),
          Divider(height: 1.0,color: Color.fromARGB(255, 220, 220, 220)),
          Container(
            height: 61,
            child:Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20,0,0,0),
                  child: Text(
                    "手机号",
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 0, 0, 0)
                    ),
                  ),
                ),
                Expanded(
                    child:Container(
                      alignment: const Alignment(1, 0),
                      child: FlatButton(
                        onPressed: (){
                          print(1);
                        },
                        child:Text(
                          "15313729066",
                          style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 68, 68, 68)

                          ),
                        ),
                      ),
                    )
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(0,0,20, 0),
                  child: Image(
                    image: AssetImage(Utils.getImgPath2("ic_arraw")),
                  ),
                )

              ],
            ),
          ),
          Divider(height: 1.0,color: Color.fromARGB(255, 220, 220, 220)),
        ],
      ),
    );
  }


  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }
}