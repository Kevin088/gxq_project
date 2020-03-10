import 'package:json_annotation/json_annotation.dart'; 
  
part 'webo_login_bean.g.dart';


@JsonSerializable()
  class WeboLoginBean extends Object {

  String resume;

  String favouriteCount;

  String gender;

  String icon;

  String snsregat;

  String secret;

  String snsUserUrl;

  String userID;

  int expiresTime;

  String token;

  int expiresIn;

  String refresh_token;

  String shareCount;

  String secretType;

  String nickname;

  String followerCount;

  String remind_in;

  WeboLoginBean(this.resume,this.favouriteCount,this.gender,this.icon,this.snsregat,this.secret,this.snsUserUrl,this.userID,this.expiresTime,this.token,this.expiresIn,this.refresh_token,this.shareCount,this.secretType,this.nickname,this.followerCount,this.remind_in,);

  factory WeboLoginBean.fromJson(Map<String, dynamic> srcJson) => _$WeboLoginBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$WeboLoginBeanToJson(this);

}

  
