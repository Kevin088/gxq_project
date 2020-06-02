class BannerInfo{
  String url;
  static List<BannerInfo> fromMapList(dynamic mapList) {
    List<BannerInfo> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }

  static BannerInfo fromMap(Map<String, dynamic> map) {
    BannerInfo pointInfo = new BannerInfo();
    pointInfo.url = map['url'];

    return pointInfo;
  }
}