import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/repositories/setting.dart';
import 'package:flutter/material.dart';

final modeProvider = ChangeNotifierProvider<isDarkNotifier>(
    (ref) => isDarkNotifier());

class isDarkNotifier extends ChangeNotifier{
  bool isDark = false;

  Future getIsDarkMode() async {
        isDark = await getMode();
        notifyListeners();
    }

    // ダークモード設定を変更
    void setIsDarkMode() {
        setMode(isDark: isDark);
        isDark = !isDark;
        notifyListeners();
    }
}