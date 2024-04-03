import 'dart:math';
import 'package:flutter/material.dart';
import 'package:online_voting_system/services/functions.dart';
import 'package:web3dart/web3dart.dart';
import 'package:confetti/confetti.dart';

class ResultScreen extends StatefulWidget {
  final Web3Client ethClient;

  const ResultScreen({Key? key, required this.ethClient}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final ConfettiController _confettiController = ConfettiController();

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Election Results'),
        backgroundColor: Color.fromARGB(255, 161, 202, 235),
      ),
      backgroundColor: Color.fromARGB(255, 161, 202, 235),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(14),
              child: FutureBuilder<List>(
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
                                var candidateData =
                                    candidatesnapshot.data![0];
                                return Card(
                                  elevation: 4,
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  color: Color.fromARGB(255, 213, 233, 217),
                                  child: ListTile(
                                    title: Text(
                                      'Name: ${candidateData[0]}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Constituency: ${candidateData[6]}',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          'Party: ${candidateData[7]}',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          'Votes: ${candidateData[9]}',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        // Text(
                                        //   'Criminal Record: ${candidateData[3]}',
                                        //   style: TextStyle(fontSize: 16),
                                        // ),
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
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                numberOfParticles: 50,
                gravity: 0.1,
                emissionFrequency: 0.1,
                colors: [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _confettiController.play();
        },
        child: Icon(Icons.celebration),
      ),
    );
  }
}
