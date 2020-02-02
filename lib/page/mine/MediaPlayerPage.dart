import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gxq_project/res/Colors.dart';
import 'package:gxq_project/utils/Utils.dart';
import 'package:orientation/orientation.dart';
import 'package:seekbar/seekbar.dart';
import 'dart:async';

import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class MediaPlayerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MediaPlayerPageState();
  }
}

class MediaPlayerPageState extends State<MediaPlayerPage> {
  VideoPlayerController _controller;
  bool _isPlaying = false;
  double _value=0.0,_secondValue=0.0;
  Timer _progressTimer;
  double totalTime=0;
  double currentTime=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    OrientationPlugin.forceOrientation(DeviceOrientation.landscapeRight);

    _controller = VideoPlayerController.asset("assets/video.mp4")
      // 播放状态
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        print("====isPlaying========$isPlaying");
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      })
      // 在初始化完成后必须更新界面
      ..initialize().then((_) {
        setState(() {});
      });

    _progressTimer = Timer.periodic(const Duration(milliseconds: 1000), (_) {
      print("==========执行了");
      if(_isPlaying){
        setState(() {
          totalTime=_controller.value.duration.inSeconds.toDouble();
          currentTime=_controller.value.position.inSeconds.toDouble();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      child: Scaffold(
        backgroundColor:Colors.black,
        body: Stack(
          children: <Widget>[
            new Center(
                child: _controller.value.initialized
                // 加载成功
                    ? new AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
                    : new Container()
            ),
            Positioned(
              bottom: 10,
              left: 20,
              child: GestureDetector(
                onTap: (){
                  if(_isPlaying){
                    _controller.pause();
                  }else{
                    _controller.play();
                  }

                },
                child: Image.asset(_isPlaying?Utils.getImgPath2("ic_play_ling"):Utils.getImgPath2("ic_play_no")),
              ),
            ),
            Positioned(
              left: 20,
              top: 30,
              child:GestureDetector(
                child: Image.asset(Utils.getImgPath2("ic_back_white")),
                onTap: (){
                  OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);
                  Navigator.pop(context);
                },
              ),
            ),

            Positioned(
              left: 30,
              right: 30,
              bottom: 30,
              child:SeekBar(
                  value: totalTime,
                  secondValue: currentTime,
                  progressColor: MyColors.color_00286B,
              ),
            ),
            Positioned(
              left: 30,
              right: 30,
              bottom: 30,
              child:SeekBar(
                value: totalTime,
                secondValue: currentTime,
                progressColor: MyColors.color_00286B,
              ),
            ),
            Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            alignment: FractionalOffset.topCenter,
              child: Text(
                  "检测体温需要注意的问题",
                style: TextStyle(color: Colors.white,fontSize: 20),
              ),
            )

          ],
        ),

      ),



      onWillPop: (){
        OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);
        Navigator.pop(context);
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  Widget getView(){
    return Container(
      color: Colors.black,
      child:  new Center(
          child: _controller.value.initialized
          // 加载成功
              ? Container(
            color: Colors.black,
            child: new AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          )
              : new Container(
            child: Text("你好阿打算的房间辣时代峰峻"),
          )
      ),
    );
  }
}
