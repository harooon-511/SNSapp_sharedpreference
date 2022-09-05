import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/common_parts.dart';

import 'package:sns_app/providers/post.dart';
import 'package:sns_app/models/post.dart';

import 'package:sns_app/providers/user.dart';
import 'package:sns_app/repositories/user.dart';

class Namechangepage extends ConsumerWidget{
  final formKey = GlobalKey<FormState>();
  Namechangepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref){
    return Scaffold(
      appBar: AppBar(
        title: const Text('ユーザー名を変更'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                initialValue: ref.watch(usernameProvider),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ユーザー名',
                ),
                onSaved: (value) {
                  setUsername(value.toString());
                  ref.read(usernameProvider.state).update((state) => value.toString()); 
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                      return 'ユーザー名を入力してください。';
                  } else if (value.length > 20) {
                      return 'ユーザー名は20文字以内で入力してください。';
                  }
                  return null;
                },
              ),
            ),
          ),
          ElevatedButton(
            onPressed: (){
            if (formKey.currentState?.validate() == true) {
              formKey.currentState?.save();
              print('Form is valid!');
              Navigator.of(context).pushNamed('mypage');
              }else{
                print('Form is invalid!');
              }     
            },   
            child: const Text('ユーザー名を変更'),
          ),
      ],
    ),
    bottomNavigationBar: MyBottomNavigationBar(),     
    );
  }
}

