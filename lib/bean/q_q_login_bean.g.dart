// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'q_q_login_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QQLoginBean _$QQLoginBeanFromJson(Map<String, dynamic> json) {
  return QQLoginBean(
    json['unionid'] as String,
    json['gender'] as String,
    json['pay_token'] as String,
    json['icon'] as String,
    json['secret'] as String,
    json['userID'] as String,
    json['expiresTime'] as int,
    json['token'] as String,
    json['expiresIn'] as int,
    json['pfkey'] as String,
    json['pf'] as String,
    json['secretType'] as String,
    json['nickname'] as String,
    json['iconQzone'] as String,
  );
}

Map<String, dynamic> _$QQLoginBeanToJson(QQLoginBean instance) =>
    <String, dynamic>{
      'unionid': instance.unionid,
      'gender': instance.gender,
      'pay_token': instance.pay_token,
      'icon': instance.icon,
      'secret': instance.secret,
      'userID': instance.userID,
      'expiresTime': instance.expiresTime,
      'token': instance.token,
      'expiresIn': instance.expiresIn,
      'pfkey': instance.pfkey,
      'pf': instance.pf,
      'secretType': instance.secretType,
      'nickname': instance.nickname,
      'iconQzone': instance.iconQzone,
    };
