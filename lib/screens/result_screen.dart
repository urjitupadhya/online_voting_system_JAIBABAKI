import 'package:flutter/material.dart';
import 'package:online_voting_system/services/functions.dart';
import 'package:web3dart/web3dart.dart';

class ResultScreen extends StatefulWidget {
  final Web3Client ethClient;

  const ResultScreen({Key? key, required this.ethClient}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Election Results'),
      ),
      body: SingleChildScrollView(
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
                              return ListTile(
                                title: Text('Name: ' +
                                    candidatesnapshot.data![0][0].toString()),
                                subtitle: Text('Votes: ' +
                                    candidatesnapshot.data![0][1].toString()),
                              );
                            }
                          })
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
