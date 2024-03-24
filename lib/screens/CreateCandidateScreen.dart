import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:online_voting_system/services/functions.dart';
import 'package:online_voting_system/screens/OngoingElectionScreen.dart';
import 'package:online_voting_system/Selection/backgrounds.dart';
import 'package:online_voting_system/Selection/responsive.dart';

class CreateCandidateScreen extends StatefulWidget {
  final Web3Client ethClient;
  final String electionName;

  const CreateCandidateScreen({
    Key? key,
    required this.ethClient,
    required this.electionName,
  }) : super(key: key);

  @override
  _CreateCandidateScreenState createState() => _CreateCandidateScreenState();
}

class _CreateCandidateScreenState extends State<CreateCandidateScreen> {
  TextEditingController candidateNameController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AnimatedAppBar(
        title: Text(
          'Create Candidate for ${widget.electionName}',
          style: TextStyle(
            color: Color.fromARGB(255, 253, 253, 255),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Image and Overlay
          Positioned.fill(
            child: Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: Image.asset(
                    'assets/icons/Ashok.jpg', // Path to your image file
                    fit: BoxFit.cover,
                  ),
                ),
                // Background Color Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(200, 0, 0, 0), // Adjust as per your preference
                          const Color.fromARGB(150, 0, 0, 0), // Adjust as per your preference
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                // Ashok Chakra Image
                Positioned.fill(
                  child: Center(
                    child: Image.asset(
                      'assets/icons/Ashok.jpg', // Path to your Ashok Chakra image file
                      width: MediaQuery.of(context).size.width * 0.6, // Adjust the width as per your preference
                      height: MediaQuery.of(context).size.width * 0.6, // Adjust the height as per your preference
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Background Widget
          Background(
            child: SingleChildScrollView(
              child: SafeArea(
                child: Responsive(
                  desktop: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(255, 139, 196, 243).withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: TextField(
                                          controller: candidateNameController,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.transparent,
                                            hintText: 'Enter candidate name',
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: _isLoading ? null : () async {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        if (candidateNameController.text.isNotEmpty) {
                                          try {
                                            await addCandidate(
                                              candidateNameController.text,
                                              widget.ethClient,
                                            );
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            _showCandidateCreatedDialog();
                                          } catch (error) {
                                            print("Error occurred: $error"); // Print the error message
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      },
                                      child: _isLoading
                                          ? CircularProgressIndicator()
                                          : Text(
                                              'Create Candidate',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(221, 240, 255, 0.682)),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        elevation: MaterialStateProperty.all<double>(4),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  mobile: MobileSelection(
                    ethClient: widget.ethClient,
                    candidateNameController: candidateNameController,
                    isLoading: _isLoading,
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      if (candidateNameController.text.isNotEmpty) {
                        try {
                          await addCandidate(
                            candidateNameController.text,
                            widget.ethClient,
                          );
                          setState(() {
                            _isLoading = false;
                          });
                          _showCandidateCreatedDialog();
                        } catch (error) {
                          print("Error occurred: $error"); // Print the error message
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      } else {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCandidateCreatedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Candidate Created'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Your candidate has been created successfully!'),
              SizedBox(height: 20),
              // You can add more widgets or customize this dialog as needed
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class MobileSelection extends StatelessWidget {
  final Web3Client ethClient;
  final TextEditingController candidateNameController;
  final bool isLoading;
  final VoidCallback onPressed;

  const MobileSelection({
    Key? key,
    required this.ethClient,
    required this.candidateNameController,
    required this.isLoading,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 139, 196, 243).withOpacity(0.5),
                        spreadRadius: 9,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: candidateNameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.transparent,
                        hintText: 'Enter candidate name',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : onPressed,
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          'Create Candidate',
                          style: TextStyle(fontSize: 18),
                        ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(221, 240, 255, 0.682)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    elevation: MaterialStateProperty.all<double>(4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AnimatedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;

  const AnimatedAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color.fromARGB(255, 211, 235, 255), const Color.fromARGB(255, 208, 215, 255)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        AppBar(
          title: title,
          backgroundColor: Color.fromRGBO(255, 195, 172, 1), // Set background color to transparent
          elevation: 0,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
