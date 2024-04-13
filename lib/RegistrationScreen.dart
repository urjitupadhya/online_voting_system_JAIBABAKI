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

  final List<String> predefinedHashNumbers = [
    '0x3CC4eC524CDe31A5366411D9072013fA1ef5A07F', //16589720c298540dc81e2ff9f536bd0f012f2f5ed893e7e1861e1eeab79f8531 //URJITUU MAIL
    '0x07616A6471196cb47cF0645c0a25D2F3Cf635032', //   101ec7d08ceaf752728f323b5b8ebc1bbeac3746420eeb6720f3ec37b491ce83 //GM4175MAIL ID 
    '0x61D328C4f9201cF29977C6c73D0b997AC179093D', // b6f15f94879ede75a03d40f0cf01df369c534c555eefecc62799d48646e86b48 //JJ COMEDYSHORTS
     '0x04822E541d6D5969c0BF00129646CBFF0a6057eA', //1092c0e88a3740f6d7cf4b5a3494561253a1a87ec35b2a2bc26cd729e5d991bd //UC ID 
    '0x6272f722769Bdc6203e19358cAEFbe152ab59418', // 99e0582bbb4aa885387e683ad8e7a69680d99cda8214f59ba8f5f2c4257d681a//EVS ID 
     '0xfDFc825704253B3D1197A1cd975cA9eef20652AE', // 8d80525b1ade062473fa04b12fbf40a0490a26616994f679e401023be7d8b27d // smart education id 
    '0x1f8e69623a0d68259B9CD57EF7682af890e45d42', // e810001482748db47c9a22cc0c2e7c31936cf2b6e7fbce6e90c8bf9a902bfca5 // Online voting System
     '0xD993BB73563B94cd6DB0943f8E76c4854e51A605', // f1d36ae50fa008f880781ac31abebae503e3e80c6dbf28edc6f50b432405dc74 //GMAILVALA ID 
  ];
  
  final List<String> predefinedPrivateKeys = [
    '16589720c298540dc81e2ff9f536bd0f012f2f5ed893e7e1861e1eeab79f8531',
    '101ec7d08ceaf752728f323b5b8ebc1bbeac3746420eeb6720f3ec37b491ce83',
    'b6f15f94879ede75a03d40f0cf01df369c534c555eefecc62799d48646e86b48',
    '1092c0e88a3740f6d7cf4b5a3494561253a1a87ec35b2a2bc26cd729e5d991bd',
    '99e0582bbb4aa885387e683ad8e7a69680d99cda8214f59ba8f5f2c4257d681a',
    '8d80525b1ade062473fa04b12fbf40a0490a26616994f679e401023be7d8b27d',
    'e810001482748db47c9a22cc0c2e7c31936cf2b6e7fbce6e90c8bf9a902bfca5',
    'f1d36ae50fa008f880781ac31abebae503e3e80c6dbf28edc6f50b432405dc74',
  ];
  
  int currentHashIndex = 0;

  void codeSent(String verificationId, int? resendToken) {
    print('Code sent to ${_phoneController.text.trim()}');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpInputScreen(verificationId: verificationId),
      ),
    );
  }

  String allocateHashNumber() {
    if (currentHashIndex < predefinedHashNumbers.length) {
      String hashNumber = predefinedHashNumbers[currentHashIndex];
      currentHashIndex++;
      return hashNumber;
    } else {
      return '';
    }
  }

  Future<void> _register(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      String completePhoneNumber = _selectedCountryCode + _phoneController.text.trim();

      DatabaseReference usersRef = FirebaseDatabase.instance.reference().child('users');
      DatabaseEvent event = await usersRef.orderByChild('aadharCardNumber').equalTo(_aadharController.text.trim()).once();
      DataSnapshot dataSnapshot = event.snapshot;

      if (dataSnapshot.value != null) {
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

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      String allocatedHashNumber = allocateHashNumber();
      String privateKey = '';

      // Map predefined hash numbers to corresponding private keys
      if (currentHashIndex - 1 < predefinedPrivateKeys.length) {
        privateKey = predefinedPrivateKeys[currentHashIndex - 1];
      }

      DatabaseReference userRef = FirebaseDatabase.instance.reference().child('users').child(userCredential.user!.uid);
      await userRef.set({
        'email': _emailController.text.trim(),
        'phoneNumber': completePhoneNumber,
        'aadharCardNumber': _aadharController.text.trim(),
        'hashNumber': allocatedHashNumber,
        'privateKey': privateKey,
      });

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
