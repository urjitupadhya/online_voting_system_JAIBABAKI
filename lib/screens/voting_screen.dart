import 'dart:math';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:online_voting_system/services/functions.dart';

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

  @override
  void initState() {
    super.initState();
    _refreshCandidates();
  }

  Future<void> _refreshCandidates() async {
    setState(() {
      _loading = true;
    });
    await Future.delayed(Duration(seconds: 0)); // Simulating fetching data
    setState(() {
      _loading = false;
    });
  }

  Color generateRandomColor() {
    final int minLightness = 150;
    final int maxLightness = 255;

    return Color.fromARGB(
      255,
      minLightness + Random().nextInt(maxLightness - minLightness),
      minLightness + Random().nextInt(maxLightness - minLightness),
      minLightness + Random().nextInt(maxLightness - minLightness),
    );
  }

  void _showVoteCountSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Your vote has been counted!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildCandidateCard(int index, List candidateInfo) {
    return Container(
      height: 150, // Fixed height for each candidate card
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8),
        color: Colors.transparent, // Set the card color to transparent
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 254, 254).withOpacity(0.5), // Transparent gray color with opacity
            borderRadius: BorderRadius.circular(8), // Optional: Add rounded corners to the card
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Candidate ${index + 1}',
                      style: TextStyle(
                        fontSize: 20,
                   //     fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      candidateInfo[0].toString(),
                      style: TextStyle(
                        fontSize: 16,
                      fontWeight: FontWeight.bold, // Bold text
                      ),
                    ),
                    Text(
                      'Constituency: ${candidateInfo[6].toString()}',
                      style: TextStyle(
                        fontSize: 16,
                    //    fontWeight: FontWeight.bold, // Bold text
                      ),
                    ),
                    Text(
                      'Party Name: ${candidateInfo[7].toString()}',
                      style: TextStyle(
                        fontSize: 16,
                  //      fontWeight: FontWeight.bold, // Bold text
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 16), // Add spacing between text and button
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await vote(index, widget.ethClient);
                      _refreshCandidates();
                      _showVoteCountSnackbar(context);
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Error: $error',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                  },
                  child: Text('Vote'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.electionName),
        backgroundColor: Color.fromARGB(255, 155, 155, 155),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshCandidates,
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(245, 184, 240, 255),
      body: Stack(
        children: [
          // Background Image with Opacity
          Opacity(
            opacity: 0.5, // Adjust the opacity as desired
            child: Image.asset(
              'assets/images/tr.png', // Replace with your image asset path
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          SingleChildScrollView(
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
  child: Text(
    'Loading Candidates',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
  ),
);
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (int i = 0;
                                  i < snapshot.data![0].toInt();
                                  i++)
                                FutureBuilder<List>(
                                  future: candidateInfo(i, widget.ethClient),
                                  builder: (context, candidatesnapshot) {
                                    if (candidatesnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                //        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return _buildCandidateCard(
                                          i, candidatesnapshot.data![0]);
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
        ],
      ),
    );
  }
}
