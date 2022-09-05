import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/repositories/album.dart';
import 'package:sns_app/models/album.dart';
import 'package:sns_app/repositories/picture.dart';

import 'package:flutter/material.dart';
import 'package:sns_app/repositories/common.dart';


final albumDataProvider = FutureProvider<List<Album>>(
  (ref) async{
  return await getAlbumData();
  },
);

final backImageProvider = ChangeNotifierProvider.family<BackImgNotifier, int>(
    (ref, albumId) {
        return BackImgNotifier(albumId: albumId);
    },
);

class BackImgNotifier extends ChangeNotifier{
  final int albumId;
  String imgurl = '';
  
  BackImgNotifier({required this.albumId});

  Future getBackImg() async {
        final backImg = await getPictureData(albumId: albumId);  // アルバムに属する写真のみ取得
        imgurl = backImg[0].thumbnailUrl;  // 取得した写真の 1 枚目の URL を imgUrl に設定
        notifyListeners();  // 忘れずに
    }
}

final favAlbumsProvider = ChangeNotifierProvider<FavAlbumNotifier>(
    (ref) => FavAlbumNotifier());

    class FavAlbumNotifier extends ChangeNotifier{
      List<Album> favList = [];  

    Future getFavAlbumList() async{
        final allAlbums = await getAlbumData();  
        favList = [];   
        await Future.forEach(allAlbums,(Album item) async{
          final isFavourite = await getFavourite('album', item.id);
          if(isFavourite==true){
            favList.add(item);
          };
        });
         notifyListeners();      
      }

    void deleteFavAlbumList(int id){
      final deleteList = favList.firstWhere((element) => element.id == id);
      favList.remove(deleteList); 
      notifyListeners();        
    }
  }