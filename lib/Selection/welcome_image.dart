import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_voting_system/constantss.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "     WELCOME TO EVS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            
            fontSize: 18, // Adjust font size as needed
            color: const Color.fromARGB(255, 139, 196, 243), // Set text color to blue
          ),
        ),
        const SizedBox(height: defaultPadding * 3),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 11,
              child: Image.asset(
                "assets/icons/uu.jpg",
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}
