import 'package:flutter/material.dart';
import 'package:online_voting_system/Home.dart';
import 'package:online_voting_system/Selection.dart';
import 'package:online_voting_system/components/curved-left-shadow.dart';
import 'package:online_voting_system/components/curved-left.dart';
import 'package:online_voting_system/components/curved-right-shadow.dart';
import 'package:online_voting_system/components/curved-right.dart';

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _showPassword = false;
  bool _isLoading = false;

  Future<void> _login(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate admin login (replace this with actual admin login logic)
      await Future.delayed(Duration(seconds: 2));

      // If login is successful, navigate to the AdminHomeScreen
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          pageBuilder: (context, animation, secondaryAnimation) => Home(),
        ),
      );
    } catch (e) {
      print('Error logging in: $e');
      // Display a snackbar with an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid username or password'),
          duration: Duration(seconds: 3), // Adjust the duration as needed
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              pageBuilder: (context, animation, secondaryAnimation) => SelectionScreen(),
            ),
          );
          return false;
        },
        child: SingleChildScrollView(
          child: Container(
            height: size.height,
            child: Stack(
              children: <Widget>[


                Positioned(top: 0, left: 0, child: CurvedLeftShadow()),
                Positioned(
                  top: 0,
                  left: 0,
                  child: CurvedLeft(
                    saffronColor1: const Color.fromARGB(255, 255, 211, 145),
                    saffronColor2: const Color.fromARGB(255, 253, 186, 165),
                  ),
                ),
                Positioned(bottom: 0, left: 0, child: CurvedRightShadow()),
                Positioned(bottom: 0, left: 0, child: CurvedRight()),
                Container(
                  height: size.height,
                  width: size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          "\nAdmin Login\n",
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        height: 200.0,
                        width: size.width * 0.8,
                        padding: const EdgeInsets.all(20.0),
                        margin: const EdgeInsets.only(bottom: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              controller: _usernameController,
                              style: TextStyle(fontSize: 18.0),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person_outline),
                                hintText: "Username",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_showPassword, // Toggle visibility
                              style: TextStyle(fontSize: 18.0),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock_outline),
                                hintText: "Password",
                                border: OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _showPassword = !_showPassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _isLoading
                          ? CircularProgressIndicator() // Display loading indicator while checking credentials
                          : ElevatedButton(
                              child: Text('Login'),
                              onPressed: () async {
                                await _login(context);
                              },
                            ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
