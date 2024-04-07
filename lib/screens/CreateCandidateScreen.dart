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
  TextEditingController dobController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController educationController = TextEditingController();
  TextEditingController placeOfBirthController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController constituencyController = TextEditingController();
  TextEditingController partyNameController = TextEditingController();
  bool hasCriminalRecord = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Create Candidate for ${widget.electionName}',
          style: TextStyle(
            color: Color.fromARGB(255, 28, 28, 28),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Widget     
         Container(
     ),
          Background(
             backgroundImage: 'assets/images/pp.jpg', 
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                    255, 139, 196, 243)
                                                .withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: TextField(
                                          controller: dobController,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.transparent,
                                            hintText: 'Enter date of birth',
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                    255, 139, 196, 243)
                                                .withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: TextField(
                                          controller: fatherNameController,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.transparent,
                                            hintText: "Enter father's name",
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                    255, 139, 196, 243)
                                                .withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: TextField(
                                          controller: educationController,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.transparent,
                                            hintText:
                                                'Enter education qualification',
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                    255, 139, 196, 243)
                                                .withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: TextField(
                                          controller: placeOfBirthController,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.transparent,
                                            hintText: 'Enter place of birth',
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromARGB(255, 0, 0, 0)
                                                .withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: TextField(
                                          controller: addressController,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.transparent,
                                            hintText: 'Enter address',
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                    255, 139, 196, 243)
                                                .withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: TextField(
                                          controller: constituencyController,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.transparent,
                                            hintText: 'Enter constituency name',
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                    255, 139, 196, 243)
                                                .withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: TextField(
                                          controller: partyNameController,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.transparent,
                                            hintText: 'Enter party name',
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
                                      onPressed: _isLoading
                                          ? null
                                          : () async {
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              if (candidateNameController
                                                  .text.isNotEmpty) {
                                                try {
                                                  await addCandidate(
                                                    candidateNameController
                                                        .text,
                                                    dobController.text,
                                                    fatherNameController.text,
                                                    educationController.text,
                                                    placeOfBirthController.text,
                                                    addressController.text,
                                                    constituencyController.text,
                                                    partyNameController.text,
                                                    hasCriminalRecord,
                                                    widget.ethClient,
                                                  );
                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                  _showCandidateCreatedDialog();
                                                } catch (error) {
                                                  print(
                                                      "Error occurred: $error"); // Print the error message
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
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color.fromRGBO(
                                                    221, 240, 255, 0.682)),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        elevation:
                                            MaterialStateProperty.all<double>(
                                                4),
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
                    dobController: dobController,
                    fatherNameController: fatherNameController,
                    educationController: educationController,
                    placeOfBirthController: placeOfBirthController,
                    addressController: addressController,
                    constituencyController: constituencyController,
                    partyNameController: partyNameController,
                    hasCriminalRecord: hasCriminalRecord,
                    isLoading: _isLoading,
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      if (candidateNameController.text.isNotEmpty) {
                        try {
                          await addCandidate(
                            candidateNameController.text,
                            dobController.text,
                            fatherNameController.text,
                            educationController.text,
                            placeOfBirthController.text,
                            addressController.text,
                            constituencyController.text,
                            partyNameController.text,
                            hasCriminalRecord,
                            widget.ethClient,
                          );
                          setState(() {
                            _isLoading = false;
                          });
                          _showCandidateCreatedDialog();
                        } catch (error) {
                          print(
                              "Error occurred: $error"); // Print the error message
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
  final TextEditingController dobController;
  final TextEditingController fatherNameController;
  final TextEditingController educationController;
  final TextEditingController placeOfBirthController;
  final TextEditingController addressController;
  final TextEditingController constituencyController;
  final TextEditingController partyNameController;
  final bool hasCriminalRecord;
  final bool isLoading;
  final VoidCallback onPressed;

  const MobileSelection({
    Key? key,
    required this.ethClient,
    required this.candidateNameController,
    required this.dobController,
    required this.fatherNameController,
    required this.educationController,
    required this.placeOfBirthController,
    required this.addressController,
    required this.constituencyController,
    required this.partyNameController,
    required this.hasCriminalRecord,
    required this.isLoading,
    required this.onPressed,
  }) : super(key: key); 
  @override
 @override
  Widget build(BuildContext context) {
    String initialEducationValue = educationController.text.isEmpty
        ? 'Select Education'
        : educationController.text;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: candidateNameController,
              decoration: InputDecoration(
                labelText: 'Candidate Name',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: dobController,
              decoration: InputDecoration(
                labelText: 'Date of Birth (dd-mm-yyyy)',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.datetime,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Date of Birth is required';
                }
                // Additional validation for date format can be added here
                return null;
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: fatherNameController,
              decoration: InputDecoration(
                labelText: "Father's Name",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: initialEducationValue,
              onChanged: (value) {
                if (value != null) {
                  educationController.text = value;
                }
              },
              decoration: InputDecoration(
                labelText: 'Education Qualification',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
              items: [
                'Select Education',
                'BA',
                'BTech',
                'Diploma',
                '12th',
                // Add more options as needed
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            TextField(
              controller: placeOfBirthController,
              decoration: InputDecoration(
                labelText: 'Place of Birth',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: constituencyController,
              decoration: InputDecoration(
                labelText: 'Constituency Name',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: partyNameController,
              decoration: InputDecoration(
                labelText: 'Party Name',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text('Create Candidate'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 4,
                textStyle: TextStyle(fontSize: 18),
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
