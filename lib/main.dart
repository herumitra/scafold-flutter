import 'package:flutter/material.dart';
import 'src/screens/splash_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
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
    );
  }
}
