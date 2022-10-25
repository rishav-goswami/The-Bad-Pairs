import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/constants.dart';
import '../config/session.dart';

class DarkThemeNotifier extends StateNotifier<bool> {
  DarkThemeNotifier() : super(true);

  void toggle() {
    state = !state;
  }

  void toggleAsBefore() async {
    bool? isDark = await Session.getBool(Constants.isDarkKey);
    if (isDark == null) {
      Session.setBool(Constants.isDarkKey, state);
      return;
    } else {
      debugPrint("isDark pref >> $isDark");
      state = isDark;
    }
  }
}

final isDarkThemeProvider =
    StateNotifierProvider<DarkThemeNotifier, bool>((ref) {
  return DarkThemeNotifier();
});
