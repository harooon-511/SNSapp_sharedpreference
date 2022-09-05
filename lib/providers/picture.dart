import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/repositories/picture.dart';
import 'package:sns_app/models/picture.dart';

import 'package:flutter/material.dart';
import 'package:sns_app/repositories/common.dart';


final pictureDataProvider = FutureProvider.family<List<Picture>,int?>(
    (ref,albumId) async {
        return await getPictureData(albumId: albumId);
    },
);

final favPicturesProvider = ChangeNotifierProvider<FavPictureNotifier>(
    (ref) => FavPictureNotifier());

    class FavPictureNotifier extends ChangeNotifier{
      List<Picture> favList = [];  

      Future getFavPictureList() async{
          final allPictures = await getPictureData();  
          favList = [];   
          await Future.forEach(allPictures,(Picture item) async{
            final isFavourite = await getFavourite('picture', item.id);
            if(isFavourite==true){
              favList.add(item);
            }
          });
          notifyListeners();      
      }

    void deleteFavPictureList(int id){
      final deleteList = favList.firstWhere((element) => element.id == id);
      favList.remove(deleteList); 
      notifyListeners();        
    }
    
  }
