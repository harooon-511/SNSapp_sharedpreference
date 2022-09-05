import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// このファイル名は picture.dart なので、freezed は picture.freezed.dart と picture.g.dart を生成する
part 'picture.freezed.dart';
part 'picture.g.dart';

@freezed
class Picture with _$Picture {
    const factory Picture({
        required int albumId,
        required int id,
        required String title,
        required String url,
        required String thumbnailUrl,
    }) = _Picture;

    factory Picture.fromJson(Map<String, Object?> json)
        => _$PictureFromJson(json);
}