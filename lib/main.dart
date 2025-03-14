import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'src/screens/splash_screen.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());

  // Atur agar aplikasi langsung fullscreen saat dijalankan
  doWhenWindowReady(() {
    final win = appWindow;
    win.maximize();
    win.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // Tambahkan navigatorKey
      debugShowCheckedModeBanner: false,
      title: 'Vimedika',
      theme: ThemeData(primarySwatch: Colors.lightGreen),
      home: const SplashScreen(),
      builder: EasyLoading.init(), // Tambahkan ini untuk menghindari error
    );
  }
}
