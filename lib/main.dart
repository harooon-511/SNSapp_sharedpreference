import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/pages/posts.dart';
import 'package:sns_app/pages/albums.dart';
import 'package:sns_app/pages/pictures.dart';
import 'package:sns_app/pages/mypage.dart';
import 'package:sns_app/pages/settings.dart';
import 'package:sns_app/pages/changeName.dart';
import 'package:sns_app/providers/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  runApp(
    const ProviderScope(
         child: MySnsApp(),
    )
  );
  // final prefs = await SharedPreferences.getInstance();
  // prefs.clear();
}

class MySnsApp extends ConsumerWidget {
  const MySnsApp({super.key});

 
  @override
  Widget build(BuildContext context, WidgetRef ref){
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ref.watch(modeProvider).isDark ?
      ThemeData.dark() : 
      ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const Postpage(),
      routes: <String, WidgetBuilder> {
        'posts': (context) => const Postpage(),
        'albums': (context) => const Albumpage(),
        'pictures': (context) => const Picturepage(),
        'mypage': (context) => const Mypage(),
        'settings': (context) => const Settingpage(),
        'changename': (context) => Namechangepage(),
      },
    );
  }
}

