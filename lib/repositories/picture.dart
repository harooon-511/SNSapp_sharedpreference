import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:sns_app/models/picture.dart';

final url = 'https://jsonplaceholder.typicode.com';



// get() で、GET リクエストを送る
Future<List<Picture>> getPictureData({int? albumId}) async{
  final queryParam = albumId == null ? '' : '?albumId=$albumId';
  final response = await http.get(
      Uri.parse('$url/photos$queryParam'),
  );  // response.body に JSON 形式のデータが含まれる
  
   if (response.statusCode == 200) {
    final List<dynamic> pictureData = jsonDecode(response.body);
        // freezed で生成された fromJson() メソッドを呼び出して Picture クラスのインスタンスを作成
        // ここでは pictureData がリスト形式なので、fromJson() の後に toList() が必要
        final pictureList = pictureData.map((e) => Picture.fromJson(e)).toList();
        return pictureList;
    } else {
        throw Exception('Failed to fetch data');
    }
    }

