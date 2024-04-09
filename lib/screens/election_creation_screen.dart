import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:online_voting_system/screens/OngoingElectionScreen.dart';
import 'package:online_voting_system/services/functions.dart';
import 'package:online_voting_system/components/curved-left-shadow.dart';
import 'package:online_voting_system/components/curved-left.dart';
import 'package:online_voting_system/components/curved-right-shadow.dart';
import 'package:online_voting_system/components/curved-right.dart';

class ElectionCreationScreen extends StatefulWidget {
  final Web3Client ethClient;

  const ElectionCreationScreen({Key? key, required this.ethClient}) : super(key: key);

  @override
  _ElectionCreationScreenState createState() => _ElectionCreationScreenState();
}

class _ElectionCreationScreenState extends State<ElectionCreationScreen> {
  TextEditingController electionNameController = TextEditingController();
  bool _isLoading = false;

  Future<void> _startElection() async {
    try {
      if (electionNameController.text.isNotEmpty) {
        setState(() {
          _isLoading = true;
        });
        await startElection(
          electionNameController.text,
          widget.ethClient,
        );
        setState(() {
          _isLoading = false;
        });
        // Show popup message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Election created successfully.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    // Navigate to the next screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OngoingElectionScreen(
                          ethClient: widget.ethClient,
                          electionName: electionNameController.text,
                        ),
                      ),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      // Handle errors
      print('Error: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to start election: $error'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent screen resizing when keyboard appears
      body: Stack(
        children: [
          // Curved Left Shadow
          Positioned(
            top: 0,
            left: 0,
            child: CurvedLeftShadow(),
          ),
          // Curved Left
          Positioned(
            top: 5,
            left: 2,
            child: CurvedLeft(
              saffronColor1: const Color.fromARGB(255, 255, 211, 145),
              saffronColor2: const Color.fromARGB(255, 253, 186, 165),
            ),
          ),
          // Curved Right Shadow
          Positioned(
            bottom: 0,
            right: 0,
            child: CurvedRightShadow(),
          ),
          // Curved Right
          Positioned(
            bottom: 0,
            right: 0,
            child: CurvedRight(),
          ),
          // Create New Election Text
          Positioned(
            top: 180, // Adjust the top position as needed
            left: 70, // Adjust the left position as needed
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Text(
                'Create New Election ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 113, 113, 113),
                ),
              ),
            ),
          ),
          // Main Container
          Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 50, 10, 0), // Adjust top padding as needed
              child: Container(
                width: 350,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(1), // Adjust opacity as needed
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 113, 203, 248).withOpacity(0.5),
                      spreadRadius: 8,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20),
                    TextField(
                      controller: electionNameController,
                      decoration: InputDecoration(
                        labelText: 'Election Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: _isLoading ? null : _startElection,
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(vertical: 15),
                        ),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 129, 205, 255),
                              ),
                            )
                          : Text(
                              'Start Election',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
