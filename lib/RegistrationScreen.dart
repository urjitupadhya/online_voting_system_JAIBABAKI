import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_voting_system/OtpInputScreen.dart';
import 'package:online_voting_system/screens/homes.dart'; // Import the Homes screen

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Create a new user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Send email verification
      await userCredential.user!.sendEmailVerification();

      // Perform phone number verification
      await _verifyPhoneNumber();

      // Display a dialog prompting the user to check their email and enter OTP
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Registration Successful'),
            content: Column(
              children: [
                Text('A verification email has been sent to ${userCredential.user!.email}.'),
                SizedBox(height: 10),
                Text('Please check your email and enter the OTP sent to your phone number.'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to the OTP input screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtpInputScreen(verificationId: 'your_verification_id'),
                    ),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error registering user: $e');
      // Display an error message to the user
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Registration Error'),
            content: Text('Failed to register. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyPhoneNumber() async {
    String phoneNumber = _phoneController.text.trim();

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval of the SMS code
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Phone verification failed: $e');
        // Handle verification failed
      },
  
      codeSent: (String verificationId, int? resendToken) {
        // Store verificationId somewhere, we will use it later
        print('Code sent to $phoneNumber');
        // Navigate to the OTP input screen with the actual verification ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpInputScreen(verificationId: verificationId),
          ),
        );
      },

      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-retrieval timeout
        print('Code auto retrieval timeout');
      },
      timeout: Duration(seconds: 60), // Timeout duration
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Text(
                  "Create an Account",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 254, 254, 254),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.text,
                  controller: _passwordController,
                  obscureText: true,
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          await _register(context);
                        },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text("Register"),
                ),
                SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    // Navigate to the Homes screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Homes()),
                    );
                  },
                  child: Text("Skip"),
                ),
                SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    // Navigate to the Login screen
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text("Already Registered? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
