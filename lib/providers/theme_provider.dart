import 'package:flutter_riverpod/flutter_riverpod.dart';

class DarkThemeNotifier extends StateNotifier<bool> {
  DarkThemeNotifier() : super(false);

  void toggle() {
    state = !state;
  }
}

final isDarkThemeProvider =
    StateNotifierProvider<DarkThemeNotifier, bool>((ref) {
  return DarkThemeNotifier();
});
