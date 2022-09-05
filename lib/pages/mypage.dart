import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sns_app/common_parts.dart';

import 'package:sns_app/pages/posts.dart';
import 'package:sns_app/pages/albums.dart';
import 'package:sns_app/pages/pictures.dart';

import 'package:sns_app/providers/post.dart';
import 'package:sns_app/providers/user.dart';
import 'package:sns_app/providers/album.dart';
import 'package:sns_app/providers/picture.dart';

import 'package:sns_app/models/post.dart';
import 'package:sns_app/repositories/user.dart';


class Mypage extends ConsumerWidget{
  const Mypage({Key? key}) : super(key: key);

    void init(WidgetRef ref){
      ref.read(favAlbumsProvider).getFavAlbumList();
      ref.read(favPicturesProvider).getFavPictureList();
      ref.read(favPostsProvider).getFavPostList();
      Future(()async{
        final username = await getUserName();
        ref.read(usernameProvider.state).update((state) => state = username);
      });
    }

  @override
  Widget build(BuildContext context, WidgetRef ref){
    init(ref);
      final postDataProvider = ref.watch(favPostsProvider);
      final albumDataProvider = ref.watch(favAlbumsProvider);
      final pictureDataProvider = ref.watch(favPicturesProvider);

     
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
      appBar: AppBar(
        title: Consumer(
          builder: (context, ref, child) =>
          Text('${ref.watch(usernameProvider)}のお気に入り'),
        ),
        actions:[
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, 'settings');
            }, 
            icon: Icon(Icons.settings)
            )
        ],
        bottom: const TabBar(
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.speaker_notes),
            ),
            Tab(
              icon: Icon(Icons.photo_library),
            ),
            Tab(
              icon: Icon(Icons.photo),
            ),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          PostsWidget(
              postData: postDataProvider.favList,
              isMyPage: true,  // マイページなので true
          ),
          AlbumsWidget(
              albumData: albumDataProvider.favList,
              isMyPage: true,  
          ),
          PicturesWidget(
              pictureData: pictureDataProvider.favList,
              isMyPage: true,  
          ),
      ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(),     
    )
    );
    
  }
}

class FavsWidget extends StatelessWidget{
  final List<Post> favData;
  const FavsWidget({super.key, required this.favData});

  @override
    Widget build(BuildContext context) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: favData.length,
          itemBuilder: (context, index) {
              final fav = favData[index];
              return FavWidget(  // FavWidget を返す
                  id: fav.id,
                  fav: fav,
              );
          },
      );
    }
}

class FavWidget extends ConsumerWidget {
    final int id;
    final Post fav;

    const FavWidget({super.key, required this.id, required this.fav});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
      final userData = ref.watch(userDataProvider);  // 6.投稿者情報を表示するため参照
      return Card(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              // 6. when() により userData の取得状況に応じて表示を切り替える
              children: userData.when(
                data: (data) => [
                  Container(  // 投稿者の名前
                    margin: const EdgeInsets.only(left: 20, top: 20, right: 8),
                    child: Text(data[fav.userId].name),
                  ),
                  Container(  // 投稿者のユーザー名（ニックネーム）
                    margin: const EdgeInsets.only(top: 20),
                    child: Text(
                        '@${data[fav.userId].username}',
                    ),
                  ),
                ],
                loading: () => [
                  const Text('loading user info...'),
                ],
                error: (err, stack) => [
                  Text('Error: $err'),
                ],
              ),
            ),
            Container(  // タイトル
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Text(
                  fav.title,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Container(  // 投稿内容
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                fav.body,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Container(  // 7. いいねボタン（後で定義）
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(right: 20),
              child: FavouriteWidget(
                id:id,
                type: 'post'),
            ),
          ],
        ),
      );
    }
}