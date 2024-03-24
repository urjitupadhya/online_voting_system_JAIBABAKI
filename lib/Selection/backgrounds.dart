import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  const Background({
    Key? key,
    required this.child,
    this.topImage = "assets/images/main.jpg",
   this.bottomImage = "assets/images/g.jpg",
   
    this.backgroundColor = Colors.white, // Default to white
  }) : super(key: key);

  final String topImage, bottomImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: backgroundColor, // Set background color here
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 77,
              left: 0,
              child: Image.asset(
                topImage,
                width: 140,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(bottomImage, width: 200),
            ),
            SafeArea(child: child),
          ],
        ),
      ),
    );
  }
}
