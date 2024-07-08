import 'package:http/http.dart';
import 'dart:convert';

class Worldtime{

  String location;
  String time='';
  String url;
  String flag;

  late bool isDayTime;
  late bool isMeridian;

  Worldtime(this.url,this.location,  this.flag);

  Future<void> getData() async {
    Response response = await get(Uri.parse('https://worldtimeapi.org/api/timezone/$url'));
    Map data = jsonDecode(response.body);
    DateTime date = DateTime.parse(data['utc_datetime']);
    // int offset = int.parse(data['utc_offset'].substring(0,3));
    int offset = int.parse(data['utc_offset'].substring(0,3));
    int minutes = int.parse(data['utc_offset'].substring(4,6));
    date = date.add(Duration(hours: offset, minutes: minutes));

    isMeridian = date.hour<=12 ? true : false;
    isDayTime = date.hour>=7 && date.hour<19? true : false;
    date = isMeridian ? date : date.add(const Duration(hours: -12));
    time=date.toString();
  }
}