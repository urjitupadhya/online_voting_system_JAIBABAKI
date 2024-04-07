import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:online_voting_system/screens/CreateCandidateScreen.dart';
import 'package:online_voting_system/services/functions.dart';
import 'package:online_voting_system/Home.dart';
import 'package:online_voting_system/Selection.dart';

class OngoingElectionScreen extends StatefulWidget {
  final Web3Client ethClient;
  final String electionName;

  const OngoingElectionScreen({
    Key? key,
    required this.ethClient,
    required this.electionName,
  }) : super(key: key);

  @override
  _OngoingElectionScreenState createState() => _OngoingElectionScreenState();
}

class _OngoingElectionScreenState extends State<OngoingElectionScreen> {
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Home()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.electionName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 194, 235, 254),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _refreshCandidates,
            ),
          ],
        ),
        body: Stack(
          children: [
            // Background Image with Opacity
            Positioned.fill(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  const Color.fromARGB(255, 215, 214, 214).withOpacity(0.5), // Adjust opacity (0.0 - 1.0)
                  BlendMode.srcOver,
                ),
                child: Image.asset(
                  'assets/images/p.png', // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _loading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text(
                            'Fetching candidates...',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    )
                  : FutureBuilder<List>(
                      future: getCandidatesNum(widget.ethClient),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data![0].toInt(),
                            itemBuilder: (context, index) {
                              return FutureBuilder<List>(
                                future: candidateInfo(index, widget.ethClient),
                                builder: (context, candidatesnapshot) {
                                  if (candidatesnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    final color = const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8); // Gray color with opacity

                                    // Extract candidate information
                                    final candidateName =
                                        candidatesnapshot.data![0][0].toString();
                                    final dob =
                                        candidatesnapshot.data![0][1].toString();
                                    final fatherName =
                                        candidatesnapshot.data![0][2].toString();
                                    final education =
                                        candidatesnapshot.data![0][3].toString();
                                    final placeOfBirth =
                                        candidatesnapshot.data![0][4].toString();
                                    final address =
                                        candidatesnapshot.data![0][5].toString();
                                    final constituency =
                                        candidatesnapshot.data![0][6].toString();
                                    final partyName =
                                        candidatesnapshot.data![0][7].toString();
                                    // final hasCriminalRecord =
                                    //     candidatesnapshot.data![0][8];

                                    return Card(
                                      elevation: 4,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 8),
                                      color: color, // Gray color with opacity
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Icon(Icons.person),
                                        ),
                                        title: Text(
                                          candidateName,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Date of Birth: $dob',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            Text(
                                              'Father\'s Name: $fatherName',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            Text(
                                              'Education Qualification: $education',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            Text(
                                              'Place of Birth: $placeOfBirth',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            Text(
                                              'Address: $address',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            Text(
                                              'Constituency: $constituency',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            Text(
                                              'Party Name: $partyName',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            //Text(
                                          //        'Has Criminal Record: $hasCriminalRecord',
                                        //        style: TextStyle(fontSize: 16),
                                          //    ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateCandidateScreen(
                  ethClient: widget.ethClient,
                  electionName: widget.electionName,
                ),
              ),
            );

            if (result != null && result) {
              _refreshCandidates();
            }
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
