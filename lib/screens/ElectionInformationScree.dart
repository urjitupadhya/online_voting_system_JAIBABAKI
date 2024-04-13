import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:online_voting_system/screens/voter_registration_screen.dart'; // Import the screen where voter registration occurs
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:online_voting_system/constants.dart';

class ElectionInformationScreen extends StatefulWidget {
  @override
  _ElectionInformationScreenState createState() =>
      _ElectionInformationScreenState();
}

class _ElectionInformationScreenState extends State<ElectionInformationScreen> {
  Client? httpClient;
  Web3Client? ethClient;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  List<Map<String, dynamic>> _electionsList = [];

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
    _retrieveData();
  }

  Future<void> _retrieveData() async {
    try {
      DatabaseEvent snapshotEvent = await _database.child('elections').once();
      if (snapshotEvent.snapshot.value != null &&
          snapshotEvent.snapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> values =
            snapshotEvent.snapshot.value as Map<dynamic, dynamic>;
        List<Map<String, dynamic>> electionsList = [];

        values.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            electionsList.add({
              'id': key,
              'name': value['name'],
              'startDate': value['startDate'],
              'endDate': value['endDate'],
              'isOpen': value['isOpen'],
            });
          }
        });

        setState(() {
          _electionsList = electionsList;
        });
      } else {
        print('Snapshot value is null or not a Map<dynamic, dynamic>');
      }
    } catch (error) {
      print('Error retrieving data: $error');
      // Handle error state or display a message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ongoing Elections'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 185, 185, 185),
                Color.fromARGB(255, 255, 255, 255)
              ], // Gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      
      backgroundColor: Color.fromARGB(245, 255, 215, 165),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/p.png'), // Change path to your image
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Color.fromARGB(255, 255, 128, 128).withOpacity(0.6),
                BlendMode.dstATop),
          ),
        ),
        child: _electionsList.isEmpty
            ? Center(
                child: Text(
                  'Fetching Ongoing Elections...',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),),)
            : ListView.builder(
                itemCount: _electionsList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
               
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                       
                      ),
                      child: ListTile(
                        title: Text(
                          'Election Campaign ${index + 1}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(196, 0, 0, 0)),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                Text('Election Name: ${_electionsList[index]['name']}',
                                    style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                        color: Color.fromARGB(255, 0, 0, 0))),
                                Text(
                                    'Commenced: ${_electionsList[index]['startDate']}',
                                    style: TextStyle(
                                      //  fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                        color: Color.fromARGB(255, 0, 0, 0))),
                                Text('Ends: ${_electionsList[index]['endDate']}',
                                    style: TextStyle(
                                 //       fontWeight: FontWeight.bold,
                                 fontSize: 16,
                                        color: Color.fromARGB(255, 0, 0, 0))),
                                Text(
                                    'Status: ${_electionsList[index]['isOpen'] ? "Active" : "Inactive"}',
                                    style: TextStyle(
                                  //      fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 0, 0, 0))),
                                SizedBox(height: 8),
                              ],
                            ),
                            TextButton(
                        onPressed: () {
  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: _,
            curve: Curves.easeOut,
          ),
          child: VoterRegistrationScreen(
            ethClient: ethClient!,
            electionName: _electionsList[index]['name'],
          ),
        );
      },
    ),
  );
},

                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<
                                        Color>(
                                    Color.fromARGB(255, 0, 0, 0)),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromARGB(255, 255, 255, 255)),
                              ),
                              child: Text('Vote'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
