import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:online_voting_system/constants.dart';
import 'package:online_voting_system/screens/election_creation_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  Client? httpClient;
  Web3Client? ethClient;
  String? electionName;

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {
            // Handle notification button press
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Handle menu button press
            },
          ),
        ],
        title: Text(
          'Admin',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(255, 255, 255, 0.914),
              Color.fromRGBO(255, 255, 255, 1),
              Color.fromRGBO(255, 255, 255, 255),
              Color.fromRGBO(255, 255, 255, 0.944),
              Color.fromRGBO(255, 255, 255, 0.961),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: screenHeight * 0.5,
                child: Stack(
                  children: [
                    Positioned(
                      top: screenHeight * 0.01,
                      left: -88,
                      child: Container(
                        height: 166,
                        width: 166,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromARGB(255, 254, 243, 243),
                              Color.fromARGB(255, 248, 174, 99),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: screenHeight * 0.3,
                      right: -100,
                      child: Container(
                        height: 166,
                        width: 166,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: screenHeight * 0.5,
                child: Stack(
                  children: [
                    Positioned(
                      top: screenHeight * 0.27,
                      left: -100,
                      child: Container(
                        height: 166,
                        width: 166,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: screenHeight * 0.01,
                      right: -100,
                      child: Container(
                        height: 166,
                        width: 166,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromARGB(255, 255, 255, 255),
                              Color.fromARGB(189, 163, 255, 87),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: screenWidth,
                      height: screenHeight,
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SizedBox(),
                              ),
                              Expanded(
                                flex: 3,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      SizedBox(width: 16),
                                      CreateElectionButton(
                                        onPressed: () async {
                                       Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        ElectionCreationScreen(ethClient: ethClient!),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  ),
);

                                        },
                                      ),
                                      SizedBox(width: 16),
                                      CreateElectionButton(
                                        onPressed: () async {
                                          // Add another action for the button
                                        },
                                      ),
                                      SizedBox(width: 16),
                                      CreateElectionButton(
                                        onPressed: () async {
                                          // Add another action for the button
                                        },
                                      ),
                                      // Add more CreateElectionButton widgets if needed
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  3, // Change the number of circles as needed
                                  (index) {
                                    return Container(
                                      height: 7,
                                      width: 7,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: index == 0
                                            ? Color.fromARGB(255, 37, 136, 99)
                                            : Color.fromARGB(255, 90, 90, 90)
                                                .withOpacity(0.2),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.01,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
bottomNavigationBar: BottomNavigationBar(
  backgroundColor: Color.fromARGB(255, 230, 255, 232), // Set the background color here
  currentIndex: _selectedIndex,
  onTap: _onItemTapped,
  selectedItemColor: Color.fromARGB(255, 220, 124, 28),
  unselectedItemColor: Color.fromARGB(255, 170, 170, 170),
  items: [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: 'Search',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ],
),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class CreateElectionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateElectionButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 86, 162, 255).withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
            ],
          ),
        ),
        child: Center(
          child: Text(
            'Create Election',
            style: TextStyle(
              color: Color.fromARGB(255, 150, 185, 255),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
