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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.electionName),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshCandidates,
          ),
        ],
      ),
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
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          'Candidate ${i + 1}',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.blue,
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        padding: EdgeInsets.all(12.0),
                                        child: Text(
                                          candidatesnapshot.data![0][0].toString(),
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: () async {
                                          // Implement the voting functionality here
                                          await vote(i, widget.ethClient);
                                          _refreshCandidates();
                                        },
                                        child: Text('Vote'),
                                      ),
                                    ],
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
