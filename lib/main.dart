import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neo_crypto/dashboard/view/dashboard.dart';
import 'package:toastification/toastification.dart';
import 'package:window_manager/window_manager.dart';
bool get isMobile => Platform.isAndroid || Platform.isIOS;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(!isMobile){
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
      size: const Size(800, 500),
      backgroundColor: Colors.transparent,
      titleBarStyle: TitleBarStyle.hidden,

    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {

      await windowManager.setSize(Size(
        800,
        500,
      ));
      await windowManager.setMinimumSize(Size(800, 500));
      await windowManager.setMaximumSize(Size(800, 500));
      await windowManager.center();
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Neo Crypto',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff3935FF)),
          useMaterial3: true,
        ),
        home: DashboardPage(),
      ),
    );
  }
}
