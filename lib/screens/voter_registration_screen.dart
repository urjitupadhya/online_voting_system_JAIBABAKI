import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voter Registration'),
      ),
      body: Container(
        padding: EdgeInsets.all(14),
        child: Column(
          children: [
            TextField(
              controller: voterAddressController,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Enter Voter Address',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () async {
                  String voterAddress =
                      voterAddressController.text.trim(); // Trim the input address
                  if (voterAddress.isNotEmpty) {
                    await authorizeVoter(
                      voterAddress,
                      widget.ethClient,
                    );

                    // Navigate to the Voting Screen after successful authorization
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VotingScreen(
                          ethClient: widget.ethClient,
                          electionName: widget.electionName,
                        ),
                      ),
                    );
                  }
                },
                child: Text('Authorize Voter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
