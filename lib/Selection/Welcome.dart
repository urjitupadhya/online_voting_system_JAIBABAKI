import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_voting_system/constantss.dart';

class Welcome extends StatelessWidget {
  const Welcome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Image.asset(
          "assets/icons/Ashok.jpg",
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        // Overlay with Opacity
        Container(
          color: Colors.black.withOpacity(0.5), // Adjust opacity as needed (0.0 to 1.0)
          width: double.infinity,
          height: double.infinity,
        ),
        // Content
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(
                "WELCOME TO EVS",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18, // Adjust font size as needed
                  color: const Color.fromARGB(255, 139, 196, 243), // Set text color to blue
                ),
              ),
            ),
            const SizedBox(height: defaultPadding * 3),
            // Add other UI elements here
          ],
        ),
      ],
    );
  }
}
