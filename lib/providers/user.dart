import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/repositories/user.dart';
import 'package:sns_app/models/user.dart';

final userDataProvider = FutureProvider<List<User>>(
    (ref) async {
        return await getUserData();
    },
);

// マイページの「○○のお気に入り」に使用
final usernameProvider = StateProvider((ref) => 'ゲスト');
