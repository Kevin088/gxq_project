// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'webo_login_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeboLoginBean _$WeboLoginBeanFromJson(Map<String, dynamic> json) {
  return WeboLoginBean(
    json['resume'] as String,
    json['favouriteCount'] as String,
    json['gender'] as String,
    json['icon'] as String,
    json['snsregat'] as String,
    json['secret'] as String,
    json['snsUserUrl'] as String,
    json['userID'] as String,
    json['expiresTime'] as int,
    json['token'] as String,
    json['expiresIn'] as int,
    json['refresh_token'] as String,
    json['shareCount'] as String,
    json['secretType'] as String,
    json['nickname'] as String,
    json['followerCount'] as String,
    json['remind_in'] as String,
  );
}

Map<String, dynamic> _$WeboLoginBeanToJson(WeboLoginBean instance) =>
    <String, dynamic>{
      'resume': instance.resume,
      'favouriteCount': instance.favouriteCount,
      'gender': instance.gender,
      'icon': instance.icon,
      'snsregat': instance.snsregat,
      'secret': instance.secret,
      'snsUserUrl': instance.snsUserUrl,
      'userID': instance.userID,
      'expiresTime': instance.expiresTime,
      'token': instance.token,
      'expiresIn': instance.expiresIn,
      'refresh_token': instance.refresh_token,
      'shareCount': instance.shareCount,
      'secretType': instance.secretType,
      'nickname': instance.nickname,
      'followerCount': instance.followerCount,
      'remind_in': instance.remind_in,
    };
