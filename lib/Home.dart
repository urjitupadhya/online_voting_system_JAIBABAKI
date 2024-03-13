import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:online_voting_system/constants.dart';
import 'package:online_voting_system/screens/voter_registration_screen.dart';
import 'package:online_voting_system/screens/result_screen.dart';
import 'package:online_voting_system/screens/election_creation_screen.dart';
import 'package:online_voting_system/screens/voting_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Client? httpClient;
  Web3Client? ethClient;
  String? electionName;

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Online Voting System'),
      ),
      body: Container(
        padding: EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final selectedElectionName = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ElectionCreationScreen(ethClient: ethClient!),
                  ),
                );

                if (selectedElectionName != null) {
                  setState(() {
                    electionName = selectedElectionName;
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VotingScreen(
                        ethClient: ethClient!,
                        electionName: selectedElectionName!,
                      ),
                    ),
                  );
                }
              },
              child: Text('Create Elections'),
            ),
            SizedBox(height: 10),
            /* Commented out the 'Register Voters' button and logic
           */ ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VoterRegistrationScreen(
                      ethClient: ethClient!,
                      electionName: 'electionName?',
                    ),
                  ),
                );
              },
              child: Text('Register Voters'),
            ),
            SizedBox(height: 10),
            
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ResultScreen(ethClient: ethClient!),
                  ),
                );
              },
              child: Text('View Results'),
            ),
          
          ],
        ),
      ),
    );
  }
}
