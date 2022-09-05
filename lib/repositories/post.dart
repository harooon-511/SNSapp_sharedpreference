import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sns_app/models/post.dart';

final url = 'https://jsonplaceholder.typicode.com';

// get() で、GET リクエストを送る
Future<List<Post>> getPostData() async{
// Future<List<Post>> getPostData() async{
  final response = await http.get(
      Uri.parse('$url/posts'),
  );  // response.body に JSON 形式のデータが含まれる
  
   if (response.statusCode == 200) {
    final List<dynamic> postData = jsonDecode(response.body);
        // freezed で生成された fromJson() メソッドを呼び出して Post クラスのインスタンスを作成
        // ここでは postData がリスト形式なので、fromJson() の後に toList() が必要
        final postList = postData.map((e) => Post.fromJson(e)).toList();
               
        return Future<List<Post>>.value(postList);
    } else {
        throw Exception('Failed to fetch data');
    }
    }


