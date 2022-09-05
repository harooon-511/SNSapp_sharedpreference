import 'package:shared_preferences/shared_preferences.dart';

Future<bool> getMode() async{
  final data = await SharedPreferences.getInstance();
  final isDark = data.getBool('isDark');
  return isDark == null ? Future.value(true) : Future.value(isDark);
}

void setMode({bool isDark=  false})async{
  final data = await SharedPreferences.getInstance();
  data.setBool('isDark', !isDark);
}