import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/common_parts.dart';

import 'package:sns_app/providers/common.dart';
import 'package:sns_app/providers/user.dart';
import 'package:sns_app/providers/album.dart';
import 'package:sns_app/models/album.dart';

import 'package:sns_app/providers/picture.dart';
import 'package:sns_app/models/picture.dart';

import 'package:cached_network_image/cached_network_image.dart';

class Albumpage extends ConsumerWidget{
  const Albumpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref){
   final albumData = ref.watch(albumDataProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('アルバム'),
      ),
      body: albumData.when(
        data: (data) => AlbumsWidget(albumData: data),
        error: (err, stack)=> Text('error:${err}'),
        loading: () => const Center(
                        child: CircularProgressIndicator(),
                        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(),     
    );
  }
}

class AlbumsWidget extends StatelessWidget{
  final List<Album> albumData;
  final bool isMyPage;
  const AlbumsWidget({super.key, required this.albumData,this.isMyPage=false});

  @override
    Widget build(BuildContext context) {
      return GridView.builder(
           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
            ), // カラム数
          shrinkWrap: true,
          itemCount: albumData.length,
          itemBuilder: (context, index) {
              final album = albumData[index];
              return AlbumWidget(  // AlbumWidget を返す
                  id: album.id,
                  album: album,
                  isMyPage: false,
              );
          },
      );
    }
}

class AlbumWidget extends ConsumerWidget {
    final int id;
    final Album album;
    final bool isMyPage;

    const AlbumWidget({super.key, required this.id, required this.album, this.isMyPage=false});  

    void toPicturesPage(WidgetRef ref, int id, context){
      ref.read(currentTabProvider.state).update((state) => 2); 
      Navigator.pushNamedAndRemoveUntil(context, 'pictures',(_)=>true, arguments: id,);
    }

    @override
    Widget build(BuildContext context, WidgetRef ref) {
      final userData = ref.watch(userDataProvider);
      ref.read(backImageProvider(album.id)).getBackImg(); 
      return GestureDetector(
        onTap: () => toPicturesPage(ref, id, context),
        child: Container(
          padding: const EdgeInsets.only(left: 8, top: 20, right: 8),
          decoration: BoxDecoration(
            // BoxDecorationの引数「image」に、NetworkImageやAssetImageを直接指定できないので、注意してください。
            image: DecorationImage(
              image: NetworkImage(
                ref.watch(backImageProvider(album.id)).imgurl,
              ),
             
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.6),
                BlendMode.dstATop,
              ),
              fit: BoxFit.cover,  
            ),
            borderRadius: BorderRadius.circular(12),
          ),
            margin: const EdgeInsets.all(2),
            child: Column(
              children: userData.when(
                data: (data) => [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                          alignment:Alignment.centerLeft,
                          child: Text(data[album.userId].name),
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            child: Text('@${data[album.userId].username}'),
                          ),
                        ],
                      ),
                      FavouriteWidget(
                          id: album.id,
                          type: 'album',
                          isMyPage: isMyPage,
                        ),
                    ], 
                  ),
                 Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 8),
                  child: Text(
                      album.title,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                      ),
                  ),
                 ),
                ],
                error: (err,stack)=>[Text('Error: $err')], 
                loading: ()=> [
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                ],
              ),
            )             
          ),
        );
      }
    }
