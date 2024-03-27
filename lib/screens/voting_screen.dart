import 'dart:math';
import 'package:flutter/material.dart';
import 'package:online_voting_system/services/functions.dart';
import 'package:web3dart/web3dart.dart';

class VotingScreen extends StatefulWidget {
  final Web3Client ethClient;
  final String electionName;

  const VotingScreen({
    Key? key,
    required this.ethClient,
    required this.electionName,
  }) : super(key: key);

  @override
  _VotingScreenState createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  bool _loading = true;
  bool _votedSuccessfully = false;

  @override
  void initState() {
    super.initState();
    _refreshCandidates();
  }

  Future<void> _refreshCandidates() async {
    setState(() {
      _loading = true;
    });
    await Future.delayed(Duration(seconds: 1)); // Simulating fetching data
    setState(() {
      _loading = false;
    });
  }

  // Function to generate random light color
  Color generateRandomColor() {
    final int minLightness = 150; // Minimum value for generating light colors
    final int maxLightness = 255; // Maximum value for generating light colors

    return Color.fromARGB(
      255, // Set alpha value to 255 for full opacity
      minLightness + Random().nextInt(maxLightness - minLightness), // Generate random lightness for red component
      minLightness + Random().nextInt(maxLightness - minLightness), // Generate random lightness for green component
      minLightness + Random().nextInt(maxLightness - minLightness), // Generate random lightness for blue component
    );
  }

  // Function to generate unique symbols for each candidate
  IconData generateUniqueSymbol() {
    List<IconData> symbols = [
      Icons.flag,
      Icons.people,
      Icons.star,
      Icons.poll,
      Icons.group,
      Icons.shield,
      Icons.verified_user,
      Icons.history,
      Icons.attach_money,
      Icons.emoji_symbols,
      Icons.account_circle,
      Icons.business,
      Icons.speaker_group,
      Icons.assignment_ind,
      Icons.pie_chart,
      Icons.fingerprint,
      Icons.business_center,
      Icons.work,
      Icons.playlist_add_check,
      Icons.timeline,
      Icons.merge_type,
    ];
    return symbols[Random().nextInt(symbols.length)];
  }

  // Function to show Snackbar indicating successful vote count
  void _showVoteCountSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Your vote has been counted!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.green, // Customize background color of the Snackbar
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.electionName),
        backgroundColor: Color.fromARGB(255, 160, 212, 255),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshCandidates,
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 160, 212, 255), // Setting the background color to blue
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(14),
          child: _loading
              ? Center(child: CircularProgressIndicator())
              : FutureBuilder<List>(
                  future: getCandidatesNum(widget.ethClient),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                  return Card(
                                    elevation: 4,
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    color: generateRandomColor(), // Assigning random light color to each card
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Candidate ${i + 1}',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                candidatesnapshot.data![0][0].toString(),
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          CircleAvatar(
                                            child: Icon(generateUniqueSymbol()), // Displaying unique symbol
                                            backgroundColor:
Colors.white, // You can customize the color as needed
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              try {
                                                // Implement the voting functionality here
                                                await vote(i, widget.ethClient);
                                                _refreshCandidates();
                                                // Show Snackbar when vote count is successful
                                                _showVoteCountSnackbar(context);
                                              } catch (error) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('════════\nAnother exception was thrown:\n$error'),
                                                  ),
                                                );
                                              }
                                            },
                                            child: Text('Vote'),
                                          ),
                                        ],
                                      ),
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
        ),
      ),
    );
  }
}
