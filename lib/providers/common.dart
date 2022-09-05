import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import 'package:sns_app/repositories/common.dart';
import 'package:flutter/material.dart';

final favouriteProvider = ChangeNotifierProvider.family<FavouriteNotifier, Tuple2<String, int>>(
    (ref, itemInfo) {
        return FavouriteNotifier(
            type: itemInfo.item1,
            id: itemInfo.item2,
        );
    },
);

class FavouriteNotifier extends ChangeNotifier {
    final String type;
    final int id;
    bool isFavourite = false;  // いいね状況
    bool initialized = false;  // getFavourite() が実行済みかどうかを表すフラグ

    FavouriteNotifier({
        required this.type,
        required this.id,
    });

    Future getItemFavourite() async{
      isFavourite = await getFavourite(type, id);
      initialized = true;
      notifyListeners();
    }

  //¥¥ voidとFutureの非同期処理の違い
    void setItemFavourite(bool v) async {
      // sharedPreferenceが変更されてもproviderに格納された値は変わってないので、変えてやる必要がある
        isFavourite = v;
        setFavourite(type, id,  isFavourite);
        notifyListeners();
    }
}


final currentTabProvider = StateProvider<int>((ref) => 0);
