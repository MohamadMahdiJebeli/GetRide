import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // پس‌زمینه
          Container(
            height: double.infinity,
            width: double.infinity,
            color: const Color.fromARGB(255, 20, 13, 13),
          ),
          // لوگو در مرکز
          Center(
            child: Image.asset(
              'assets/images/GRLogo.png',
            ),
          ),
          // انیمیشن تاکسی
          TweenAnimationBuilder<double>(
            duration: const Duration(seconds: 3), // مدت زمان انیمیشن
            tween: Tween<double>(begin: -100, end: screenWidth + 100), // حرکت افقی از چپ به راست
            builder: (context, xPosition, child) {
              final yPosition = screenHeight / 1.5 +
                  50 * ((xPosition) / screenWidth); 
              return Positioned(
                left: xPosition, // حرکت افقی
                top: yPosition, // موقعیت عمودی
                child: child!,
              );
            },
            child: Image.asset(
              'assets/images/taxi.png',
              width: 80,
            ),
          ),
        ],
      ),
    );
  }
}
