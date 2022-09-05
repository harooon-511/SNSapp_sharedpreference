import 'package:shared_preferences/shared_preferences.dart';

Future<bool> getFavourite(String type, int id)async{
  final data = await SharedPreferences.getInstance();
  final isFavourite = data.getBool('$type-$id');
  return isFavourite == null ? Future.value(false) : Future.value(isFavourite);
}

void setFavourite(String type, int id, bool isFavourite)async{
  final data = await SharedPreferences.getInstance();
  data.setBool('$type-$id', isFavourite);
}

