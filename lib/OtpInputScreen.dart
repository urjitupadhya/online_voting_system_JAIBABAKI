import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:online_voting_system/HomeScreen.dart';
class OtpInputScreen extends StatelessWidget {
  final String verificationId;

  OtpInputScreen({Key? key, required this.verificationId}) : super(key: key);

  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _verifyOtp(BuildContext context) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: _otpController.text.trim(),
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // After successful OTP verification, navigate to the new home screen
      if (userCredential.user != null) {
  Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => HomeScreen(), // Instantiate HomeScreen
  ),
);

      }
    } catch (e) {
      print('Error verifying OTP: $e');
      // Handle verification failure
      _showErrorSnackbar(context, 'The verification code is invalid. Please check and try again.');
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter the OTP sent to your mobile number',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              controller: _otpController,
              decoration: InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _verifyOtp(context);
              },
              style: ElevatedButton.styleFrom(
              //  primary: Colors.blue,
            //  onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text("Verify OTP"),
            ),
          ],
        ),
      ),
    );
  }
}

