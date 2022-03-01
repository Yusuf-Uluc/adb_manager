import 'package:adb_manager/constants/constants.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

import 'themes/theme.dart';
import 'views/views.dart';

Future<void> main() async {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
  doWhenWindowReady(() {
    const initialSize = Size(600, 450);
    appWindow.maxSize = const Size(800, 600);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadiusM),
        child: const HomeView(),
      ),
    );
  }
}
