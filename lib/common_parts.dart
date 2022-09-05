import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/providers/common.dart';
import 'package:sns_app/providers/post.dart';
import 'package:sns_app/providers/album.dart';
import 'package:sns_app/providers/setting.dart';
import 'package:sns_app/providers/picture.dart';
import 'package:sns_app/repositories/common.dart';
import 'package:sns_app/repositories/picture.dart';
// tupleのインポートがお手本に抜けてる
import 'package:tuple/tuple.dart';

class MyBottomNavigationBar extends ConsumerWidget{
  const MyBottomNavigationBar({Key? key}) : super(key: key);

  void changeBottomBarIndex(int index, BuildContext context, WidgetRef ref) {
    ref.read(currentTabProvider.state).update((state) => index);
    switch (index){
      case 0:
      Navigator.of(context).pushNamed('posts');
      break;
      case 1:
      Navigator.of(context).pushNamed('albums');
      break;
      case 2:
      Navigator.of(context).pushNamed('pictures');
      break;
      case 3:
      Navigator.of(context).pushNamed('mypage');
      break;
      default:
      print('【異常系】： switch文の引数になりえないデータです。');
      break;
    }
  }

@override
Widget build(BuildContext context, WidgetRef ref) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    //  backgroundColor: Colors.pink,
      items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.speaker_notes),
              label: '投稿',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.collections),
              label: 'アルバム',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.image),
              label: '写真',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'マイページ',
          ),
      ],
      // タップされた時の処理
      currentIndex: ref.watch(currentTabProvider), 
      unselectedItemColor: ref.read(modeProvider).isDark ? Colors.white: Colors.black38,              
      onTap: (index)=>changeBottomBarIndex(index, context,ref),      
    );
}
}

class FavouriteWidget extends ConsumerWidget {
  final int id;
  final String type;
  final bool isMyPage;

  const FavouriteWidget({
    // このkeyが何かよくわからない
        super.key,
        required this.id,
        required this.type,
        this.isMyPage = false,
    });

  //¥¥ awaitないのにasyncあるのは？
  void _toggleFavourite(WidgetRef ref, Tuple2<String, int> itemInfo) async{
    // ここ、教材ではreadだがwatchにしないといいねボタンの見た目が変化しない。
    final isFavourite = ref.read(favouriteProvider(itemInfo)).isFavourite;
    ref.watch(favouriteProvider(itemInfo)).setItemFavourite(!isFavourite);

    if(type == 'album'){
      final pictures = await getPictureData(albumId: id);
      final AlbumIsFavourite = ref.read(favouriteProvider(itemInfo)).isFavourite;
      for (final picture in pictures){
        setFavourite(
          'picture',
          picture.id,
          AlbumIsFavourite,
         );
         ref.read(favouriteProvider(Tuple2('picture',picture.id))).setItemFavourite(AlbumIsFavourite);
      }
    }

    if(isMyPage){
      switch (type) {
        case 'post':
          ref.watch(favPostsProvider).deleteFavPostList(id);
          break;
        case 'picture':
          ref.watch(favPicturesProvider).deleteFavPictureList(id);
          break;
        case 'album':
          ref.watch(favAlbumsProvider).deleteFavAlbumList(id);                  
          break;
        default:
          print('エラーです');
          break;
      }
    }
  }

@override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemInfo = Tuple2<String, int>(type, id);
    // 多分見本には抜けてる
    final isFavourite= ref.watch(favouriteProvider(itemInfo)).isFavourite;
    // initializedが変更された時だけ再描画できるselectメソッド
    final initialized = ref.watch(favouriteProvider(itemInfo).select((value) => value.initialized));
    if(!initialized){
      ref.read(favouriteProvider(itemInfo)).getItemFavourite();
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

      return IconButton(
        // ()=>がないとThis expression has a type of 'void' so its value can't be used.エラーが出る
        // https://stackoverflow.com/questions/63226568/flutter-this-function-has-a-return-type-of-void-and-cannot-be-used
        onPressed: () => _toggleFavourite(ref,itemInfo),
        icon: isFavourite
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border),
              color: Colors.pink,
      );
    }
}
  
