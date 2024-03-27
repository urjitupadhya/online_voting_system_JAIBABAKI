import 'package:flutter/material.dart';
import 'package:online_voting_system/screens/homes.dart';
import 'package:web3dart/web3dart.dart';
import 'package:online_voting_system/screens/CreateCandidateScreen.dart';
import 'package:online_voting_system/services/functions.dart';
import 'package:online_voting_system/Home.dart';
import'package:online_voting_system/Selection.dart';
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
        backgroundColor: const Color.fromARGB(255, 194, 235, 254),
        appBar: AnimatedAppBar(
          backgroundColor: const Color.fromARGB(
              255, 194, 235, 254), // Same as background color
          title: Text(
            widget.electionName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white, // Text color
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _refreshCandidates,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _loading
              ? Center(child: CircularProgressIndicator())
              : FutureBuilder<List>(
                  future: getCandidatesNum(widget.ethClient),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                                final color = Colors
                                    .primaries[index % Colors.primaries.length];

                                return Card(
                                  elevation: 4,
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  child: Container(
                                    color: color.withOpacity(0.3),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(Icons
                                            .person), // Placeholder icon, replace with candidate logo
                                      ),
                                      title: Text(
                                        'Candidate ${index + 1}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        candidatesnapshot.data![0][0]
                                            .toString(),
                                        style: TextStyle(fontSize: 16),
                                      ),
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

class AnimatedAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final Widget title;
  final List<Widget>? actions;

  const AnimatedAppBar({
    Key? key,
    required this.backgroundColor,
    required this.title,
    this.actions,
  }) : super(key: key);

  @override
  _AnimatedAppBarState createState() => _AnimatedAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AnimatedAppBarState extends State<AnimatedAppBar> {
  late Color _backgroundColor;

  @override
  void initState() {
    super.initState();
    _backgroundColor = widget.backgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: _backgroundColor,
      title: widget.title,
      actions: widget.actions,
    );
  }
}
