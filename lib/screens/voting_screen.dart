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
      backgroundColor: const Color.fromARGB(255, 160, 212, 255),
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
                              color: generateRandomColor(),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Candidate ${i + 1}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            candidatesnapshot.data![0][0]
                                                .toString(),
                                            style:
                                            TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            'Constituency: ${candidatesnapshot.data![0][6].toString()}',
                                            style:
                                            TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            'Party Name: ${candidatesnapshot.data![0][7].toString()}',
                                            style:
                                            TextStyle(fontSize: 16),
                                          ),
                              
                                        ],
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          try {
                                            await vote(
                                                i, widget.ethClient);
                                            _refreshCandidates();
                                            _showVoteCountSnackbar(
                                                context);
                                          } catch (error) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    '════════\nAnother exception was thrown:\n$error'),
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
