import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';


// このファイル名は main.dart なので、freezed は main.freezed.dart と main.g.dart を生成する
part 'post.freezed.dart';
part 'post.g.dart';

@freezed
class Post with _$Post {
    const factory Post({
        required int userId,
        required int id,
        required String title,
        required String body,
    }) = _Post;

    factory Post.fromJson(Map<String, Object?> json)
        => _$PostFromJson(json);
}