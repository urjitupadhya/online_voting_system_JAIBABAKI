import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final String backgroundImage; // Path to the background image

  const Background({
    Key? key,
    required this.child,
    this.backgroundColor = Colors.white,
    required this.backgroundImage, // Pass the background image path
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              backgroundImage,
              fit: BoxFit.cover,
            ),
          ),

          // Solid Color Overlay
          Container(
            color: backgroundColor.withOpacity(0.5), // Adjust the opacity as needed
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
          ),

          // Safe Area for Content
          SafeArea(
            child: child,
          ),
        ],
      ),
    );
  }
}
