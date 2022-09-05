import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';


part 'user.freezed.dart';
part 'user.g.dart';


@freezed
class User with _$User {
    const factory User({
        required int id,
        required String name,
        required String username,
        required Map address,
          // required String street,
          // required String suite,
          // required String city,
          // required int zipcode,
          // required Map geo,
          //   required double lat,
          //   required double lng,
        required String phone,
        required String website,
        required Map company,
          // required String name,
          // required String catchPhrase,
          // required String bs,
    }) = _User;

    factory User.fromJson(Map<String, Object?> json)
        => _$UserFromJson(json);
}