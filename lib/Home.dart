import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:online_voting_system/constants.dart';
import 'package:online_voting_system/screens/election_creation_screen.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Client? httpClient;
  Web3Client? ethClient;

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
  }

  @override
  void dispose() {
    httpClient?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 255, 255)!,
              const Color.fromARGB(255, 255, 255, 255)!,
            ],
          ),
        ),
        child: SafeArea(
          child: HomePage(ethClient: ethClient),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final Web3Client? ethClient;

  const HomePage({Key? key, required this.ethClient}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> categories = ["Admin", "Elections", "Voters", "Elections Info"];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0,vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                 ' Admin Dashboard',
                style: TextStyle(color: const Color.fromARGB(255, 133, 133, 133), fontWeight: FontWeight.bold, fontSize: 25),
              ),
              SizedBox(height: 10),
              Container(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) => buildCategory(categories[index]),
                ),
              ),
              SizedBox(height: 0),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            'Manage Elections',
            style: TextStyle(color: Colors.grey[700], fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) => buildItem(context, categories[index]),
            ),
          ),
        ),
        SizedBox(height:0),
      ],
    );
  }

  Widget buildCategory(String title) {
    return GestureDetector(
      onTap: () {
        // Handle category selection if needed
      },
      child: Container(
        width: 150,
        margin: EdgeInsets.only(right: 10,),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 213, 212, 212),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        if (title == "Admin" && widget.ethClient != null) {
          // Navigate to ElectionCreationScreen with custom page transition
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
                opacity: animation,
                child: ElectionCreationScreen(ethClient: widget.ethClient!),
              ),
            ),
          );
        }
      },
      child: Container(
        width: 300,
        height: 390,
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 157, 158, 159),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 101, 110, 120).withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // Space evenly between title and image
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(bottom: 20), // Adjust padding to move the image up
                child: Image.asset(
                  'assets/images/pp.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
