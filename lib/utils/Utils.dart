class Utils{
  static String getImgPath(String name, {String format: 'png'}) {
    return 'assets/images/$name.$format';
  }
  static String getImgPath2(String name) {
    return 'assets/images/$name.png';
  }
}

