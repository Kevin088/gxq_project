class PointInfo{
  String id;       //uuid
  int createTime; //创建时间
  String tempType;//温度类型
  String userId;  //用户id
  String isUpload;//是否同步到服务器了  后端不需要
  String blueToothId;//蓝牙设备id
  String blueToothName;//蓝牙名字
  String deviceId; //手机设备id
  String tempValueMax;//最大温度值
  String tempValueMin;//最小温度值
  String tempValueAverage;//平均温度
  String detailInfo;//json串 存放 x y坐标点
  int status;//状态 0 正常 1 警报 2 中断

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['createTime'] = createTime;
    map['tempType'] = tempType;
    map['userId'] = userId;
    map['isUpload'] = isUpload;
    map['blueToothId'] = blueToothId;
    map['blueToothName'] = blueToothName;
    map['deviceId'] = deviceId;
    map['tempValueMax'] = tempValueMax;
    map['tempValueMin'] = tempValueMin;
    map['tempValueAverage'] = tempValueAverage;
    map['detailInfo'] = detailInfo;
    map['status'] = status;
    return map;
  }


  static PointInfo fromMap(Map<String, dynamic> map) {
    PointInfo pointInfo = new PointInfo();
    pointInfo.id = map['id'];
    pointInfo.createTime = map['createTime'];
    pointInfo.userId = map['userId'];
    pointInfo.isUpload = map['isUpload'];
    pointInfo.blueToothId = map['blueToothId'];
    pointInfo.blueToothName = map['blueToothName'];
    pointInfo.deviceId = map['deviceId'];
    pointInfo.tempValueMax = map['tempValueMax'];
    pointInfo.tempValueMin = map['tempValueMin'];
    pointInfo.tempValueAverage = map['tempValueAverage'];
    pointInfo.detailInfo = map['detailInfo'];
    pointInfo.status = map['status'];
    return pointInfo;
  }

  static List<PointInfo> fromMapList(dynamic mapList) {
    List<PointInfo> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }

}