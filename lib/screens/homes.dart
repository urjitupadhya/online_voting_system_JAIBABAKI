import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:online_voting_system/screens/ContactUsScreen.dart';
import 'package:online_voting_system/screens/election_creation_screen.dart';
import 'package:online_voting_system/screens/voting_screen.dart';
import 'package:web3dart/web3dart.dart';
import 'package:online_voting_system/screens/ElectionInformationScree.dart';
import 'package:online_voting_system/screens/Feedback.dart';
import 'package:online_voting_system/screens/settings_screen.dart';

import 'package:online_voting_system/constants.dart';
import 'package:online_voting_system/screens/voter_registration_screen.dart';
import 'package:online_voting_system/screens/result_screen.dart';

class Homes extends StatelessWidget {
  const Homes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen(); // Use BaseScreen as the main screen
  }
}

const Color orangeGreenMixture = Color.fromRGBO(139, 208, 255, 0.875); // Orange color

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomesContent(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255), // Light purple color
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomAppBar(),
          Expanded(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: Color.fromARGB(255, 247, 255, 255),
        backgroundColor: orangeGreenMixture, // Use the custom color here
        elevation: 0,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            
          )
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

class HomesContent extends StatefulWidget {
  const HomesContent({Key? key}) : super(key: key);

  @override
  _HomesContentState createState() => _HomesContentState();
}

class _HomesContentState extends State<HomesContent> {
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
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Body(
              navigateToScreen: navigateToScreen,
            ),
          ],
        ),
      ),
    );
  }

void navigateToScreen(BuildContext context, String categoryName) {
  Widget? destinationScreen; // Define variable to hold the destination screen

  if (categoryName == 'Voting') {
    destinationScreen = VoterRegistrationScreen(
      ethClient: ethClient!,
      electionName: 'Ram ji',
    );
  } else if (categoryName == 'Result') {
    destinationScreen = ResultScreen(ethClient: ethClient!);
  }

  // Check if destinationScreen is not null
  if (destinationScreen != null) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: destinationScreen, // Use destination screen directly
          );
        },
      ),
    );
  }
}

}

class CustomAppBar extends StatelessWidget {
  
  final TextEditingController _searchController = TextEditingController();

  

  static const Color appBarColor1 = Color(0xFFB2DFDB);
  static const Color appBarColor2 = Color(0xFF80CBC4);

  String _getGreeting() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening ';
    }


  }

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();

    return Container(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
      height: 230,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.3],
          colors: [
            appBarColor1,
            appBarColor2,
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  // Navigate to the Profile Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ElectionInformationScreen(),
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/icons/uu.jpg'),
                  radius: 30,
                ),
              ),
              Text(
                greeting,
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          // Two Circle-type Icons for Book Finder and Course Listing
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleIconButton(
                icon: Icons.search,
                label: 'Information',
                onPressed: () {
                  // Handle the click for book finder
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>ElectionInformationScreen(),
                    ),
                  );
                },
              ),
              CircleIconButton(
                icon: Icons.view_list,
                label: 'Contact Us',
                onPressed: () {
                  // Handle the click for ContactUs
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                       ContactUsScreen(),
                    ),
                  );
                },
              ),
              CircleIconButton(
                icon: Icons.article,
                label: 'Feedback',
                onPressed: () {
                       Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                       FeedbackScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Body extends StatelessWidget {
  final Function navigateToScreen;

  const Body({required this.navigateToScreen});

  @override
  Widget build(BuildContext context) {
    final firstRowCategories = categoryList.sublist(0,1);
    final secondRowCategories = categoryList.sublist(1,2);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [],
          ),
        ),
        SizedBox(
          height: kCategoryCardImageSize + 20.0,
          child: Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              scrollDirection: Axis.horizontal,
              itemCount: firstRowCategories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CategoryCard(
                    category: firstRowCategories[index],
                    onTap: () =>
                        navigateToScreen(context, firstRowCategories[index].name),
                    navigateToScreen: navigateToScreen,
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 30),
        SizedBox(
          height: kCategoryCardImageSize + 20.0,
          child: Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              scrollDirection: Axis.horizontal,
              itemCount: secondRowCategories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CategoryCard(
                    category: secondRowCategories[index],
                    onTap: () =>
                        navigateToScreen(context, secondRowCategories[index].name),
                    navigateToScreen: navigateToScreen,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const CircleIconButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Color.fromARGB(255, 17, 17, 17),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}
class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;
  final Function navigateToScreen;

  const CategoryCard({
    required this.category,
    required this.onTap,
    required this.navigateToScreen,
  });

  @override
  Widget build(BuildContext context) {
    double cardWidth = category.name == 'Voting' || category.name == 'Result'
        ? 220.0 // Set a custom width for Voting and Result categories
        : 180.0; // Default width for other categories

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: cardWidth, // Use the calculated width
        height: 180, // Set the height of the card
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 159, 181, 255),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 91, 146, 255).withOpacity(.1),
              blurRadius: 5.0,
              spreadRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category, // Add an icon for the category
              size: 48,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Category {
  final String name;
  final String thumbnail;

  Category({
    required this.name,
    required this.thumbnail,
  });
}

final categoryList = <Category>[
  Category(name: 'Voting', thumbnail: ''), // Removed the image path
  Category(name: 'Result', thumbnail: ''), // Removed the image path
];

const double kCategoryCardImageSize = 140.0;
