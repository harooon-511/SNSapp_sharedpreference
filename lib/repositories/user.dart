import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:sns_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

final url = 'https://jsonplaceholder.typicode.com';

// get() で、GET リクエストを送る
Future<List<User>> getUserData() async{
  final response = await http.get(
      Uri.parse('$url/users'),
  );  // response.body に JSON 形式のデータが含まれる
  
   if (response.statusCode == 200) {
    final List<dynamic> userData = jsonDecode(response.body);
        // freezed で生成された fromJson() メソッドを呼び出して User クラスのインスタンスを作成
        // ここでは userData がリスト形式なので、fromJson() の後に toList() が必要
        final userList = userData.map((e) => User.fromJson(e)).toList();
        return Future<List<User>>.value(userList);
    } else {
        throw Exception('Failed to fetch data');
    }
}

Future<String> getUserName() async{
  final data = await SharedPreferences.getInstance();
  final username = data.getString('username');
    // 未設定の場合は username が null
    // username が null なら 'ゲスト' と返す
  return username == null ? Future.value('ゲスト') : Future.value(username);
}

void setUsername(String newUsername) async {
    final data = await SharedPreferences.getInstance();
    data.setString('username', newUsername);
}

