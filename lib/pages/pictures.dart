import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/common_parts.dart';
import 'package:sns_app/providers/common.dart';

import 'package:sns_app/providers/picture.dart';
import 'package:sns_app/models/picture.dart';

import 'package:sns_app/providers/user.dart';
import 'package:sns_app/models/user.dart';

class Picturepage extends ConsumerWidget{
  const Picturepage({Key? key}) : super(key: key);


  //¥¥ */ この<bool>とかの使い分けがよくわからない
  Future<bool> changeActiveTab(WidgetRef ref)async{
    ref.read(currentTabProvider.state).update((state) => state = 1);
    return true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref){
    dynamic albumId = ModalRoute.of(context)!.settings.arguments;
    final pictureData = ref.watch(pictureDataProvider(albumId));
    
    return WillPopScope(
      onWillPop: ()=>changeActiveTab(ref),
      child: Scaffold(
      appBar: AppBar(
        title: const Text('写真'),
      ),
      body: pictureData.when(
        data: (data) => PicturesWidget(pictureData: data),
        error: (err, stack)=> Text('error:${err}'),
        loading: () => const Center(
                        child: CircularProgressIndicator(),
                        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(),     
    ),
    );    
  }
}

class PicturesWidget extends StatelessWidget{
  final List<Picture> pictureData;
  final bool isMyPage; 
  const PicturesWidget({super.key, required this.pictureData,this.isMyPage=false});

  @override
    Widget build(BuildContext context) {
      return GridView.builder(
           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
            ), // カラム数
          shrinkWrap: true,
          itemCount: pictureData.length,
          itemBuilder: (context, index) {
              final picture = pictureData[index];
              return PictureWidget(  // PictureWidget を返す
                  id: picture.id,
                  picture: picture,
                  isMyPage: false,
              );
          },
      );
    }
}

class PictureWidget extends ConsumerWidget {
    final int id;
    final Picture picture;
    final bool isMyPage; 
    

    const PictureWidget({super.key, required this.id, required this.picture, this.isMyPage=false});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
      return Stack(
        children: [
          Container(
              margin: const EdgeInsets.all(2),
              child: Image.network(picture.thumbnailUrl,
                errorBuilder: (c, o, s) {
                  print('Load failed : ${c.toString()}');
                  return const Icon(
                    Icons.error,
                    color: Colors.red,
                  );
                },
              ),
          ),
              // Text(picture.thumbnailUrl),
          Container(
              alignment: Alignment.bottomRight,
              child: FavouriteWidget(
                  id: picture.id,
                  type: 'picture',
                  isMyPage: isMyPage,
              ),
          ),
        ],
      );
    }
}