import 'package:date_format/date_format.dart';

class Utils{
  static String getImgPath(String name, {String format: 'png'}) {
    return 'assets/images/$name.$format';
  }
  static String getImgPath2(String name) {
    return 'assets/images/$name.png';
  }


  static String getTemperature(List<int> param){
    double value=0;
    if(param!=null&&param.length==3){
      value=(param[0]-48)*100.0;
      value+=(param[1]-48)*10;
      value+=param[2]-48;
      value=value*0.0625;
    }
    return formatNum(value,2);
  }

  static String formatNum(double num,int postion){
    if((num.toString().length-num.toString().lastIndexOf(".")-1)<postion){
      //小数点后有几位小数
      return( num.toStringAsFixed(postion).substring(0,num.toString().lastIndexOf(".")+postion+1).toString());
    }else{
      return( num.toString().substring(0,num.toString().lastIndexOf(".")+postion+1).toString());
    }
  }
  static double formatDouble(String num){
    try{
      return double.parse(num);
    }catch(Exception){

    }
    return 0;
  }

  static String getTime(){
    return formatDate(DateTime.now(), [yyyy, "-", mm, "-", dd, " "," ", HH, ":", nn, ":", ss]);
  }
  static String formatXvalue(int time){
    time++;
    time=time*10;
    if(time<60){
        return "0:$time";
    }else if(time<60*60){
        return "${(time/60).floor()}:${time%60}";
    }else{
      return "${(time/60*60).floor()}:${((time-(time/60*60).floor())/60).floor()}:${time%60}";
    }
  }



}

