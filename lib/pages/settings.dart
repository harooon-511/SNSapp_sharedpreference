import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/common_parts.dart';

import 'package:sns_app/providers/setting.dart';
import 'package:sns_app/providers/post.dart';
import 'package:sns_app/models/post.dart';
import 'package:sns_app/providers/user.dart';

import 'package:sns_app/repositories/setting.dart';

class Settingpage extends ConsumerWidget{
  const Settingpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final isDark = ref.watch(modeProvider).isDark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: ListView(
        children: [
          InkWell(
            onTap: ()=>Navigator.pushNamed(context, 'changename'),
            child: const Card(
              child: ListTile(
                title: Text('名前を登録'),
                trailing: Icon(Icons.navigate_next),         
              ),
            ),
          
          ),
          Card(
            child: ListTile(
              title: Text('ダークモード'),
              trailing:
              // Switch(
            //     value: isDark,
            //     onChanged: (value) {
            //         ref.read(modeProvider).setIsDarkMode();
            //     },
            // ),
               IconButton(
                onPressed:(){
                  ref.watch(modeProvider).setIsDarkMode();
                },
                icon: ref.watch(modeProvider).isDark ? Icon(Icons.toggle_on) : Icon(Icons.toggle_off)
              ),
            ),
          ),
        ]
      ),
      bottomNavigationBar: MyBottomNavigationBar(),     
    );
  }
}

class PostsWidget extends StatelessWidget{
  final List<Post> postData;
  const PostsWidget({super.key, required this.postData});

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
              );
          },
      );
    }
}

class PostWidget extends ConsumerWidget {
    final int id;
    final Post post;

    const PostWidget({super.key, required this.id, required this.post});

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
                          type: 'post'),
                    ),
                ],
            ),
        );
    }
}