import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/splashscreen_controller.dart';

class SplashscreenView extends GetView<SplashscreenController> {
  const SplashscreenView({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/bg_logo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.8,
            left: 0.0,
            right: 0.0,
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF044526)),
              ),
            ),
          ),
          const Positioned(
            bottom: 16.0, // Adjust the bottom spacing as needed
            left: 0.0,
            right: 0.0,
            child: Center(
              child: Text(
                'Created by Pake-H©',
                style: TextStyle(
                  color: Colors.brown, // Set the text color to white
                  fontSize: 14.0, // Adjust the font size as needed
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}