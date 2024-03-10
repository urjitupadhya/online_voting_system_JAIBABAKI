// onboarding_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:online_voting_system/RegistrationScreen.dart';
import 'package:online_voting_system/constant.dart';
import 'package:online_voting_system/custom_online.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Constants.kWhiteColor,  // White background representing the central color of the Indian flag
      extendBody: true,
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            Positioned(
              top: screenHeight * 0.1,
              left: -88,
              child: Container(
                height: 166,
                width: 166,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 255, 150, 3),  // Saffron color representing the top color of the Indian flag
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 200,
                    sigmaY: 200,
                  ),
                  child: Container(
                    height: 166,
                    width: 166,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.3,
              right: -100,
              child: Container(
                height: 200,
                width: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Constants.kGreenColor,  // Green color representing the bottom color of the Indian flag
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 200,
                    sigmaY: 200,
                  ),
                  child: Container(
                    height: 200,
                    width: 200,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenHeight * 0.07,
                  ),
                  CustomOutline(
                    strokeWidth: 4,
                    radius: screenWidth * 0.8,
                    padding: const EdgeInsets.all(4),
                    width: screenWidth * 0.8,
                    height: screenWidth * 0.8,
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(255, 234, 113, 7),  // Saffron color representing the top color of the Indian flag
                          Constants.kWhiteColor.withOpacity(0),
                          Constants.kGreenColor.withOpacity(0.1),
                          Constants.kGreenColor,
                        ],
                        stops: const [
                          0.2,
                          0.4,
                          0.6,
                          1
                        ]),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          alignment: Alignment.bottomLeft,
                          image: AssetImage('assets/indian.jpg'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.09,
                  ),
                  Text(
                    'Participate in\nOnline Voting',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 67, 51, 51).withOpacity(0.85),
                      fontSize: screenHeight <= 667 ? 18 : 34,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  Text(
                    'Exercise your right to vote\nanytime, anywhere',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 28, 7, 7).withOpacity(0.75),
                      fontSize: screenHeight <= 667 ? 12 : 16,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  CustomOutline(
                    strokeWidth: 3,
                    radius: 20,
                    padding: const EdgeInsets.all(3),
                    width: 160,
                    height: 38,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Constants.kPinkColor,
                        Constants.kGreenColor,
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegistrationScreen()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Constants.kPinkColor.withOpacity(0.5),
                              Constants.kGreenColor.withOpacity(0.5),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Get Started',
                            style: TextStyle(
                              fontSize: 14,
                              color: Constants.kWhiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) {
                        return Container(
                          height: 7,
                          width: 7,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == 0
                                ? Color.fromARGB(255, 0, 237, 150)
                                : Color.fromARGB(255, 255, 72, 0).withOpacity(0.2),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
