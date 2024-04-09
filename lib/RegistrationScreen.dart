import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:online_voting_system/components/curved-left-shadow.dart';
import 'package:online_voting_system/components/curved-left.dart';
import 'package:online_voting_system/components/curved-right-shadow.dart';
import 'package:online_voting_system/components/curved-right.dart';
import 'package:online_voting_system/OtpInputScreen.dart';
import 'package:online_voting_system/screens/homes.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  bool _isLoading = false;
  String _selectedCountryCode = '+91';
  bool _obscurePassword = true;

  // Function to handle code sent
  void codeSent(String verificationId, int? resendToken) {
    // Store verificationId somewhere, we will use it later
    print('Code sent to ${_phoneController.text.trim()}');
    // Navigate to the OTP input screen with the actual verification ID
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpInputScreen(verificationId: verificationId),
      ),
    );
  }

  // Function to register user
  Future<void> _register(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      String completePhoneNumber = _selectedCountryCode + _phoneController.text.trim();

      // Check if Aadhar card number already exists
      DatabaseReference usersRef = FirebaseDatabase.instance.reference().child('users');
      DatabaseEvent event = await usersRef.orderByChild('aadharCardNumber').equalTo(_aadharController.text.trim()).once();
      DataSnapshot dataSnapshot = event.snapshot;

      if (dataSnapshot.value != null) {
        // Aadhar card number already exists, show pop-up message
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Registration Error'),
              content: Text('User already registered with this Aadhar card number.'),
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
        setState(() {
          _isLoading = false;
        });
        return;
      }
      // Proceed with registration
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      DatabaseReference userRef = FirebaseDatabase.instance.reference().child('users').child(userCredential.user!.uid);
      await userRef.set({
        'email': _emailController.text.trim(),
        'phoneNumber': completePhoneNumber,
        'aadharCardNumber': _aadharController.text.trim(),
      });

      // Request phone authentication
      await _auth.verifyPhoneNumber(
        phoneNumber: completePhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (String verificationId) {},
      );

      await userCredential.user!.sendEmailVerification();

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Registration Successful'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'A verification email has been sent to ${userCredential.user!.email}.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Please check your email and click on the verification link to complete your registration process. After email verification, enter the OTP sent to your phone number.',
                ),
              ],
            ),
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
    } catch (e) {
      print('Error registering user: $e');
      String errorMessage = 'Failed to register. Please try again.';
      if (e is FirebaseAuthException) {
        errorMessage = e.message ?? errorMessage;
      } else if (e is Exception) {
        errorMessage = e.toString();
      }
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Registration Error'),
            content: Text(errorMessage),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      body: Container(
        child: Stack(
          children: <Widget>[
            Positioned(top: 0, left: 0, child: CurvedLeftShadow()),
            Positioned(
              top: 0,
              left: 0,
              child: CurvedLeft(
                saffronColor1: const Color.fromARGB(255, 255, 211, 145),
                saffronColor2: const Color.fromARGB(255, 253, 186, 165),
              ),
            ),
            Positioned(bottom: 0, left: 0, child: CurvedRightShadow()),
            Positioned(bottom: 0, left: 0, child: CurvedRight()),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 30),
                      Text(
                        "\nRegister\n",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 139, 196, 243).withOpacity(0.8),
                        ),
                      ),
                      SizedBox(height: 5),
                      Column(
                        children: [
                          _buildInputField(Icons.mail, "Email", TextInputType.emailAddress, _emailController),
                          SizedBox(height: 5),
                          _buildInputField(Icons.lock, "Password", TextInputType.text, _passwordController, isPassword: true),
                          SizedBox(height: 5),
                          _buildInputField(Icons.credit_card, "Aadhar Card", TextInputType.number, _aadharController),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              CountryCodePicker(
                                onChanged: (CountryCode? countryCode) {
                                  setState(() {
                                    _selectedCountryCode = countryCode!.dialCode!;
                                  });
                                },
                                initialSelection: 'IN',
                                favorite: ['+91', 'IN'],
                              ),
                              SizedBox(width: 5),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromARGB(255, 139, 196, 243).withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.phone_android, color: Color.fromARGB(255, 139, 196, 243)),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: "Phone Number",
                                            border: InputBorder.none,
                                          ),
                                          keyboardType: TextInputType.phone,
                                          controller: _phoneController,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isLoading ? null : () async {
                          await _register(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: Color.fromARGB(255, 178, 217, 249),
                          shadowColor: Color.fromARGB(255, 245, 245, 245),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                            : Text("Register", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    IconData icon,
    String label,
    TextInputType inputType,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(icon, color: Color.fromARGB(255, 139, 196, 243)),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 139, 196, 243).withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  labelText: label,
                  hintText: label,
                  hintStyle: TextStyle(color: Color.fromARGB(255, 139, 196, 243)),
                  border: InputBorder.none,
                ),
                keyboardType: inputType,
                controller: controller,
                obscureText: isPassword && _obscurePassword,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
