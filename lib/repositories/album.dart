import 'package:http/http.dart' as http;
import 'package:sns_app/models/album.dart';
import 'dart:async';
import 'dart:convert';


final url = 'https://jsonplaceholder.typicode.com';

Future<List<Album>> getAlbumData() async{
 final response = await http.get(Uri.parse('$url/albums'));

 if (response.statusCode==200){
  final List<dynamic> postData = jsonDecode(response.body);
    final albumList = postData.map((e) => Album.fromJson(e)).toList();
    return Future<List<Album>>.value(albumList);
 }else{
  throw Exception('Failed to fetch data');
 }

}