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
    _confettiController.dispose(); // Dispose the confetti controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Election Results'),
        backgroundColor: const Color.fromARGB(255, 161, 202, 235), // Change app bar background color
      ),
      backgroundColor: const Color.fromARGB(255, 161, 202, 235), // Set background color to light blue
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
                                return Card(
                                  elevation: 4,
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  color: Color.fromARGB(255, 213, 233, 217), // Set the color of the box to white
                                  child: ListTile(
                                    title: Text(
                                      'Name: ' +
                                          candidatesnapshot.data![0][0]
                                              .toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Votes: ' +
                                          candidatesnapshot.data![0][1]
                                              .toString(),
                                      style: TextStyle(
                                        fontSize: 16,
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
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality
                    .explosive, // Set the direction of the confetti blast
                shouldLoop: false, // Do not loop the confetti animation
                numberOfParticles: 50, // Number of confetti particles
                gravity: 0.1, // Set the gravity effect
                emissionFrequency: 0.1, // Set the emission frequency
                colors: [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                ], // Set the colors of the confetti
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Trigger confetti effect when the button is pressed
          _confettiController.play();
        },
        child: Icon(Icons.celebration),
      ),
    );
  }
}
