import 'package:flutter/material.dart';
import 'package:quadbtech/homescreen.dart';

class SplashScreen extends StatelessWidget {
  // Duration for splash screen delay
  static const Duration _splashDelay = Duration(seconds: 3);

  // Constructor with an optional key parameter
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Navigate to HomeScreen after the splash delay
    Future.delayed(_splashDelay, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  HomeScreen()),
      );
    });

    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Take only as much space as needed
          children:  [
            // Image widget with logo
            ImageAsset(),
            SizedBox(height: 20), // Space between image and text
            Center(
              child: Text(
                '      Discover Unlimited\nEntertainment with Playflix',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageAsset extends StatelessWidget {
  // Constructor with an optional key parameter
  const ImageAsset({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'lib/assets/123.jpg', // Ensure this asset exists in your assets directory
      width: 399, // Adjust size as needed
      height: 399,
    );
  }
}
