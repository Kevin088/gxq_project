import 'package:json_annotation/json_annotation.dart'; 
  
part 'q_q_login_bean.g.dart';


@JsonSerializable()
  class QQLoginBean extends Object {

  String unionid;

  String gender;

  String pay_token;

  String icon;

  String secret;

  String userID;

  int expiresTime;

  String token;

  int expiresIn;

  String pfkey;

  String pf;

  String secretType;

  String nickname;

  String iconQzone;

  QQLoginBean(this.unionid,this.gender,this.pay_token,this.icon,this.secret,this.userID,this.expiresTime,this.token,this.expiresIn,this.pfkey,this.pf,this.secretType,this.nickname,this.iconQzone,);

  factory QQLoginBean.fromJson(Map<String, dynamic> srcJson) => _$QQLoginBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$QQLoginBeanToJson(this);

}

  
