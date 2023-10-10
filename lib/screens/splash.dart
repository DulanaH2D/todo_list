import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Set the background color of your splash screen
      child: Center(
        child: Image.asset(
          'assets/todologo.png', // Replace with the path to your custom image
          width: 100.0, // Set the width of the image
          height: 100.0, // Set the height of the image
        ),
      ),
    );
  }
}