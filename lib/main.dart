import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:badminton_team_up/config/constants.dart';
import 'package:badminton_team_up/config/session.dart';
import 'package:badminton_team_up/providers/theme_provider.dart';
import 'package:badminton_team_up/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/src/enum.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

// Future<void> toggleTheme() async {
//   bool? isDark = await Session.getBool(Constants.isDarkKey);
//   if (isDark == null) {
//     Session.setBool(Constants.isDarkKey, isDarkTheme);
//     return;
//   } else {
//     isDarkTheme = isDark;
//   }
// }

bool isDarkTheme = true;

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    isDarkTheme = ref.watch(isDarkThemeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Bad Pairs',
      theme: ThemeData(
        useMaterial3: true,
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        colorSchemeSeed: Colors.black,
      ),
      home: AnimatedSplashScreen(
          splash: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sports_tennis_outlined,
                size: 58,
                color: Colors.white,
                shadows: [
                  for (double i = 1; i < 5; i++)
                    Shadow(
                      color: Colors.purple,
                      blurRadius: 9 * i,
                    )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                "The Bad Pairs !",
                style: TextStyle(
                  color: Colors.white,
                  shadows: [
                    for (double i = 1; i < 4; i++)
                      Shadow(
                        color: Colors.pink,
                        blurRadius: 9 * i,
                      )
                  ],
                ),
              )
            ],
          ),
          splashTransition: SplashTransition.scaleTransition,
          pageTransitionType: PageTransitionType.leftToRightWithFade,
          backgroundColor: Colors.black45,
          splashIconSize: 250,
          duration: 4000,
          nextScreen: const MyHomePage(title: 'Welcome To Bad Pairs !')),
    );
  }
}
