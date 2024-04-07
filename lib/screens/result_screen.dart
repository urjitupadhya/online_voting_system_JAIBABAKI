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
  late AssetImage _backgroundImage; // Declare the AssetImage variable

  @override
  void initState() {
    super.initState();
    _backgroundImage = AssetImage('assets/images/ww.png'); // Load the background image
  }

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
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Background Image with Opacity
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: _backgroundImage, // Use the loaded background image
                  fit: BoxFit.cover,
                ),
              ),
              child: Opacity(
                opacity: 0.5, // Adjust the opacity as desired
                child: Container(
                  color: Colors.white, // Background color with opacity
                ),
              ),
            ),
          ),
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
                                  color: Colors.white.withOpacity(0.7), // Transparent with opacity
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
          // Confetti Animation
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
