import 'package:flutter/material.dart';
import 'package:online_voting_system/components/curved-left-shadow.dart';
import 'package:online_voting_system/components/curved-left.dart';
import 'package:online_voting_system/components/curved-right-shadow.dart';
import 'package:online_voting_system/components/curved-right.dart';
import 'package:online_voting_system/services/functions.dart';
import 'package:web3dart/web3dart.dart';
import 'package:online_voting_system/screens/voting_screen.dart';

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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
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
                              }
                            }
                            setState(() {
                              _isLoading = false;
                            });
                          },
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('Authorize Voter'),
                  ),
                ],
              ),
            ),
          ),
        ],
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
