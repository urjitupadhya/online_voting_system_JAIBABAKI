import 'package:flutter/material.dart';
import 'package:online_voting_system/services/functions.dart';
import 'package:web3dart/web3dart.dart';

class ElectionInfo extends StatefulWidget {
  final Web3Client ethClient;
  final String electionName;

  const ElectionInfo({
    Key? key,
    required this.ethClient,
    required this.electionName,
  }) : super(key: key);

  @override
  _ElectionInfoState createState() => _ElectionInfoState();
}

class _ElectionInfoState extends State<ElectionInfo> {
  TextEditingController addCandidateController = TextEditingController();
  TextEditingController authorizeVoterController = TextEditingController();
  TextEditingController constituencyController = TextEditingController();
  TextEditingController partyNameController = TextEditingController();
  bool hasCriminalRecord = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.electionName)),
      body: Container(
        padding: EdgeInsets.all(14),
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    FutureBuilder<List>(
                      future: getCandidatesNum(widget.ethClient),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Text(
                          snapshot.data![0].toString(),
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    Text('Total Candidates')
                  ],
                ),
                Column(
                  children: [
                    FutureBuilder<List>(
                      future: getTotalVotes(widget.ethClient),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Text(
                          snapshot.data![0].toString(),
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    Text('Total Votes')
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: addCandidateController,
                    decoration: InputDecoration(
                      hintText: 'Enter Candidate Name',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: constituencyController,
                    decoration: InputDecoration(
                      hintText: 'Enter Constituency Name',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: partyNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter Party Name',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Checkbox(
                  value: hasCriminalRecord,
                  onChanged: (value) {
                    setState(() {
                      hasCriminalRecord = value!;
                    });
                  },
                ),
                Text('Has Criminal Record?'),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                addCandidate(
                  addCandidateController.text,
                  // Added additional parameters for candidate
                  "01/01/1990", // Sample dob
                  "John Doe Sr.", // Sample father's name
                  "Bachelor's Degree", // Sample education qualification
                  "New York", // Sample place of birth
                  "0x123...789", // Sample address
                  constituencyController.text,
                  partyNameController.text,
                  hasCriminalRecord,
                  widget.ethClient,
                );
              },
              child: Text('Add Candidate'),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: authorizeVoterController,
                    decoration: InputDecoration(
                      hintText: 'Enter Voter address',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    authorizeVoter(
                      authorizeVoterController.text,
                      widget.ethClient,
                    );
                  },
                  child: Text('Authorize Voter'),
                )
              ],
            ),
            Divider(),
            FutureBuilder<List>(
              future: getCandidatesNum(widget.ethClient),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Column(
                    children: [
                      for (int i = 0; i < snapshot.data![0].toInt(); i++)
                        FutureBuilder<List>(
                          future: candidateInfo(i, widget.ethClient),
                          builder: (context, candidatesnapshot) {
                            if (candidatesnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return ListTile(
                                title: Text(
                                  'Name: ' +
                                      candidatesnapshot.data![0][0].toString(),
                                ),
                                subtitle: Text(
                                  'Votes: ' +
                                      candidatesnapshot.data![0][1].toString(),
                                ),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    vote(i, widget.ethClient);
                                  },
                                  child: Text('Vote'),
                                ),
                              );
                            }
                          },
                        ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
