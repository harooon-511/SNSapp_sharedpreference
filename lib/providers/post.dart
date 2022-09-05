import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/repositories/post.dart';
import 'package:sns_app/models/post.dart';
import 'package:flutter/material.dart';
import 'package:sns_app/repositories/common.dart';

final postDataProvider = FutureProvider<List<Post>>(
    (ref) async {
        return await getPostData();
    },
);

final favPostsProvider = ChangeNotifierProvider<FavPostNotifier>(
    (ref) => FavPostNotifier());

    class FavPostNotifier extends ChangeNotifier{
      List<Post> favList = [];  

    Future getFavPostList() async{
        final allPosts = await getPostData();  
        favList = [];   
        await Future.forEach(allPosts, (Post item) async{
          final isFavourite = await getFavourite('post', item.id);
          if(isFavourite==true){
            favList.add(item);
          }
        });
         notifyListeners();      
      }

    void deleteFavPostList(int id){
      final deleteList = favList.firstWhere((element) => element.id == id);
      favList.remove(deleteList); 
      notifyListeners();        
    }
  }
