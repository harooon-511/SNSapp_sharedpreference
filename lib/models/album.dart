import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// このファイル名は main.dart なので、freezed は main.freezed.dart と main.g.dart を生成する
part 'album.freezed.dart';
part 'album.g.dart';

@freezed
class Album with _$Album {
    const factory Album({
        required int userId,
        required int id,
        required String title,
    }) = _Album;

    factory Album.fromJson(Map<String, Object?> json)
        => _$AlbumFromJson(json);
}