import 'package:flutter/material.dart';
import 'package:delayed_display/delayed_display.dart';
import '../utils/constants.dart';
import 'auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 7), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // Pastikan ini center
          children: [
            DelayedDisplay(
              delay: const Duration(milliseconds: 500),
              child: Text(
                'VIMEDIKA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: ViColors.mainDefault,
                ),
              ),
            ),
            const SizedBox(height: 15),
            DelayedDisplay(
              delay: const Duration(milliseconds: 1250),
              child: Text(
                'Memberi Solusi Terintegrasi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ViColors.greyColor,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Membungkus teks-teks lainnya agar rata kiri
            Padding(
              padding: const EdgeInsets.only(
                left: 50,
              ), // Sesuaikan dengan kebutuhan
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DelayedDisplay(
                    delay: const Duration(milliseconds: 2000),
                    child: Text(
                      'Profesional',
                      style: TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: ViColors.greyColor,
                      ),
                    ),
                  ),
                  DelayedDisplay(
                    delay: const Duration(milliseconds: 2750),
                    child: Text(
                      'Terstruktur',
                      style: TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: ViColors.greyColor,
                      ),
                    ),
                  ),
                  DelayedDisplay(
                    delay: const Duration(milliseconds: 3500),
                    child: Text(
                      'Multi Platform (Desktop, Web & Mobile)',
                      style: TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: ViColors.greyColor,
                      ),
                    ),
                  ),
                  DelayedDisplay(
                    delay: const Duration(milliseconds: 4750),
                    child: Text(
                      'Customizable & Scalable',
                      style: TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: ViColors.greyColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
