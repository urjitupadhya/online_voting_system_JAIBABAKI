import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_voting_system/screens/homes.dart';
import 'package:online_voting_system/Admin.dart';
import 'package:online_voting_system/components/curved-left-shadow.dart';
import 'package:online_voting_system/components/curved-left.dart';
import 'package:online_voting_system/components/curved-right-shadow.dart';
import 'package:online_voting_system/components/curved-right.dart';
import 'package:online_voting_system/RegistrationScreen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _showPassword = false;
  bool _isLoading = false;
  bool _isAdminLoading = false;

  Future<void> _loginWithEmailAndPassword(BuildContext context,
      {bool isAdmin = false}) async {
    if (isAdmin) {
      setState(() {
        _isAdminLoading = true;
      });
    } else {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      if (isAdmin) {
        // Simulating admin login for demonstration purpose
        print('Admin login');
        await Future.delayed(Duration(milliseconds: 500));
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration:
                Duration(milliseconds: 1500), // Adjust transition duration
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            pageBuilder: (context, animation, secondaryAnimation) => Admin(),
          ),
        );
      } else {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _usernameController.text.trim(),
          password: _passwordController.text,
        );

        if (userCredential.user != null) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration:
                  Duration(milliseconds: 1500), // Adjust transition duration
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              pageBuilder: (context, animation, secondaryAnimation) => Homes(),
            ),
          );
        }
      }
    } catch (e) {
      print('Error logging in: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid username or password'),
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      if (isAdmin) {
        setState(() {
          _isAdminLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
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
                        "\n\nVoter Login ",
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 139, 196, 243), // Saffron color
                        ),
                      ),
                    ),
                    Container(
                      height: 200.0,
                      width: size.width * 0.8,
                      padding: const EdgeInsets.all(20.0),
                      margin: const EdgeInsets.only(bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255), // White color
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 139, 196, 243).withOpacity(0.5),
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
                              hintStyle: TextStyle(
                                color: Color.fromARGB(255, 139, 196, 243), // Hint text color
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_showPassword,
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
                              hintStyle: TextStyle(
                                color: Color.fromARGB(255, 139, 196, 243), // Hint text color
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _isLoading
                        ? CircularProgressIndicator()
                        : GestureDetector(
                            onTap: () async {
                              await _loginWithEmailAndPassword(context);
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Color.fromARGB(255, 139, 196, 243), // Blue color
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                    SizedBox(height: 20.0),
                    _isAdminLoading
                        ? CircularProgressIndicator()
                        : Positioned(
                            top: 10.0, // Adjust top position as needed
                            right: 10.0, // Adjust right position as needed
                            child: GestureDetector(
                              onTap: () async {
                                setState(() {
                                  _isAdminLoading = true; // Show loading indicator only for register button
                                });
                                await Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration: Duration(milliseconds: 1500), // Adjust transition duration
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                    pageBuilder: (context, animation, secondaryAnimation) => RegistrationScreen(),
                                  ),
                                );
                                setState(() {
                                  _isAdminLoading = false; // Hide loading indicator when returning from registration screen
                                });
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 139, 196, 243), // Saffron color
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
