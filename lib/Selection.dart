import 'package:flutter/material.dart';
import 'package:online_voting_system/Login.dart';
import 'package:online_voting_system/Admin.dart';
import 'package:online_voting_system/Selection/background.dart';
import 'package:online_voting_system/Selection/responsive.dart';
import 'package:online_voting_system/Selection/login_signup_btn.dart';
import 'package:online_voting_system/Selection/welcome_image.dart';

class SelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
            child: SingleChildScrollView(
              child: SafeArea(
                child: Responsive(
                  desktop: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: WelcomeImage(),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 450,
                              child: LoginAndSignupBtn(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  mobile: MobileSelection(),
                ),
              ),
            ),
          ),
          // Positioned(
          //   bottom: 0,
          //   right: 0,
          //   child: Image.asset(
          //     'assets/images/g.jpg',
          //     width: 150, // Increase width here
          //     height: 150, // Increase height here
          //   ),
        //  ),
        ],
      ),
    );
  }
}

class MobileSelection extends StatelessWidget {
  const MobileSelection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        WelcomeImage(),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: LoginAndSignupBtn(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'User Type Selection Demo',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: SelectionScreen(),
  ));
}
