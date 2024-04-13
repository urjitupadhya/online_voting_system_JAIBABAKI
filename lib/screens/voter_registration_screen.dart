import 'package:flutter/material.dart';
import 'package:online_voting_system/components/curved-left-shadow.dart';
import 'package:online_voting_system/components/curved-left.dart';
import 'package:online_voting_system/components/curved-right-shadow.dart';
import 'package:online_voting_system/components/curved-right.dart';
import 'package:online_voting_system/screens/Hash.dart';
import 'package:online_voting_system/services/functions.dart';
import 'package:web3dart/web3dart.dart';
import 'package:online_voting_system/screens/voting_screen.dart';
import 'package:online_voting_system/screens/Hash.dart'; // Import HashScreen.dart

class VoterRegistrationScreen extends StatefulWidget {
  final Web3Client ethClient;
  final String electionName;

  const VoterRegistrationScreen({
    Key? key,
    required this.ethClient,
    required this.electionName,
  }) : super(key: key);

  @override
  _VoterRegistrationScreenState createState() =>
      _VoterRegistrationScreenState();
}

class _VoterRegistrationScreenState extends State<VoterRegistrationScreen> {
  TextEditingController voterAddressController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enter Voter Address',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(228, 145, 187, 255),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: voterAddressController,
                        decoration: InputDecoration(
                          hintText: 'Enter Voter Address',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _isLoading
                      ? CircularProgressIndicator()
                      : Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 178, 217, 249),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 245, 245, 245),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    String voterAddress =
                                        voterAddressController.text.trim();
                                    if (voterAddress.isNotEmpty) {
                                      try {
                                        // Authorize the voter using the provided voter address
                                        await authorizeVoter(
                                          voterAddress,
                                          widget.ethClient,
                                        );
                                        _showSuccessSnackBar(context);
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => VotingScreen(
                                              ethClient: widget.ethClient,
                                              electionName: widget.electionName,
                                            ),
                                          ),
                                        );
                                      } catch (e) {
                                        print('Error authorizing voter: $e');
                                        _showErrorSnackbar(
                                            context,
                                            'Failed to authorize voter. '
                                            'Please try again.');
                                      } finally {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    }
                                  },
                            icon: Icon(Icons.arrow_forward),
                            iconSize: 30,
                            color: Colors.white,
                          ),
                        ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      _navigateToHashScreen(context);
                    },
                    child: Text(
                      'Get Your Voter ID',
                      style: TextStyle(
                        color: Color.fromARGB(228, 145, 187, 255),
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToHashScreen(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.easeInOutCubic;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          return HashScreen();
        },
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voter Authorized successfully'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
