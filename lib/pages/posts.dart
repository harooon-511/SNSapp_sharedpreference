import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/common_parts.dart';

import 'package:sns_app/providers/post.dart';
import 'package:sns_app/models/post.dart';

import 'package:sns_app/providers/user.dart';

class Postpage extends ConsumerWidget{
  const Postpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref){
   final postData = ref.watch(postDataProvider);
   
    return Scaffold(
      appBar: AppBar(
        title: const Text('投稿'),
      ),
      body: postData.when(
        data: (data) => PostsWidget(postData: data),
        error: (err, stack)=> Text('error:${err}'),
        loading: () => const Center(
                        child: CircularProgressIndicator(),
                        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(),     
    );
  }
}

class PostsWidget extends StatelessWidget{
  final List<Post> postData;
  final bool isMyPage; 
  const PostsWidget({super.key, required this.postData, this.isMyPage=false});

  @override
    Widget build(BuildContext context) {
      return ListView.builder(
          // ListViewは何も指定しないと利用可能なスペースを全て使用してしまう
          // shrinkWrap を true にすると、ListView が必要なスペースのみ使うようになる
          shrinkWrap: true,
          itemCount: postData.length,
          itemBuilder: (context, index) {
              final post = postData[index];
              return PostWidget(  // PostWidget を返す
                  id: post.id,
                  post: post,
                  isMyPage: false,
              );
          },
      );
    }
}

class PostWidget extends ConsumerWidget {
    final int id;
    final Post post;
    final bool isMyPage; 

    const PostWidget({super.key, required this.id, required this.post,this.isMyPage=false});

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
                                    child: Text(data[post.userId].name),
                                ),
                                Container(  // 投稿者のユーザー名（ニックネーム）
                                    margin: const EdgeInsets.only(top: 20),
                                    child: Text(
                                        '@${data[post.userId].username}',
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
                            post.title,
                            textAlign: TextAlign.left,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                    ),
                    Container(  // 投稿内容
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                            post.body,
                            textAlign: TextAlign.left,
                            style: const TextStyle(fontSize: 16),
                        ),
                    ),
                    Container(  // 7. いいねボタン（後で定義）
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.only(right: 20),
                        child: FavouriteWidget(
                          id:id,
                          type: 'post',
                          isMyPage: isMyPage),
                    ),
                ],
            ),
        );
    }
}