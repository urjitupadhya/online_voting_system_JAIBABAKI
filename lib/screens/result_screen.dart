import 'dart:math';
import 'package:flutter/material.dart';
import 'package:online_voting_system/services/functions.dart';
import 'package:web3dart/web3dart.dart';
import 'package:confetti/confetti.dart';

class ResultScreen extends StatefulWidget {
  final Web3Client ethClient;

  const ResultScreen({Key? key, required this.ethClient}) : super(key: key);

  @override
  ResultScreenState createState() => ResultScreenState();
}

class ResultScreenState extends State<ResultScreen> {
  final ConfettiController _confettiController = ConfettiController();
  late AssetImage _backgroundImage;
  late Future<List> _candidatesNumFuture;
  late Future<List<List<dynamic>>> _candidatesInfoFuture;

  @override
  void initState() {
    super.initState();
    _backgroundImage = AssetImage('assets/images/ww.png');
    _candidatesNumFuture = getCandidatesNum(widget.ethClient);
    _candidatesInfoFuture = _candidatesNumFuture.then((candidatesNum) {
      List<Future<List<dynamic>>> infoFutures = [];
      for (int i = 0; i < candidatesNum[0].toInt(); i++) {
        infoFutures.add(candidateInfo(i, widget.ethClient));
      }
      return Future.wait(infoFutures);
    });
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
          Opacity(
            opacity: 0.5, // Adjust the opacity as desired
            child: Image.asset(
              'assets/images/ww.png', // Image path for your background
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(14),
              child: FutureBuilder<List<List<dynamic>>>(
                future: _candidatesInfoFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                    //      CircularProgressIndicator(),
                          SizedBox(height: 300),
                          Text(
                            'Fetching Candidates...', // Bold text
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error fetching candidates'),
                    );
                  } else {
                    List<Widget> candidateCards = [];
                    for (int i = 0; i < snapshot.data!.length; i++) {
                      var candidateData = snapshot.data![i][0];
                      candidateCards.add(
                        Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          color: Colors.white.withOpacity(0.7),
                          child: ListTile(
                            title: Text(
                              'Name: ${candidateData[0]}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                        ),
                      );
                    }
                    return Column(
                      children: candidateCards,
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
