<<<<<<< Updated upstream:agriconnect/lib/login_screen.dart
import 'package:flutter/material.dart';
import 'ProfilePage1.dart'; // Import your ProfilePage1 view
import 'register_screen.dart';
import 'package:agriconnect/ForgetPassword.dart'; // Import your ForgetPassword screen
=======
// Import necessary packages and classes
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'package:admin/services/AuthService.dart';
import '/models/User_Login.dart';  // Adjust the import based on the actual path and file name
import 'ForgetPassword.dart';
import 'register_screen.dart';
import 'package:admin/mainscreeninterface.dart';
>>>>>>> Stashed changes:lib/screens/dashboard/login_screen.dart

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bggg.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: isSmallScreen
              ? Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              _Logo(),
              _FormContent(),
            ],
          )
              : Container(
            padding: const EdgeInsets.all(32.0),
            constraints: const BoxConstraints(maxWidth: 800),
            child: Row(
              children: const [
                Expanded(child: _Logo()),
                Expanded(
                  child: Center(child: _FormContent()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              'assets/logo_black.png',
              width: isSmallScreen ? 150 : 300,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Welcome to AgriConnect World!",
              textAlign: TextAlign.center,
              style: isSmallScreen
                  ? Theme.of(context).textTheme.headline6?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              )
                  : Theme.of(context).textTheme.headline5?.copyWith(
                color: Colors.black87,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              ' ',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white30,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'LOGIN',
              style: TextStyle(
                color: Colors.black87,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            _gap(),
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _phoneNumberController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }

                      // Use a regular expression to check if the input contains exactly 8 digits
                      RegExp regex = RegExp(r'^\d{8}$');

                      if (!regex.hasMatch(value)) {
                        return 'Please enter exactly 8 numbers';
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'Enter your number',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  _gap(),
                  TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }

                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  _gap(),
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _rememberMe = value;
                          });
                        },
                      ),
                      Text(
                        'Remember me',
                        style: TextStyle(
                          color: Colors.black87,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  _gap(),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black45,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            final phoneNumber =
                                _phoneNumberController.text;
                            final password = _passwordController.text;

                            try {
                              // Call your login service here using phoneNumber and password
                              final user = await _authService.login(phoneNumber, password);

                              if (user != null) {
                                // Handle successful login
                                // Save user details to local storage
                                await saveUserDetailsToLocal(user);

                                // Navigate to MainScreenInterface on successful login
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainScreenInterface(),
                                  ),
                                      (route) => false, // This removes all previous routes from the stack
                                );
                              } else {
                                // Handle the case where the user data is null (login failed)
                                print('Login failed');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Login failed. Please check your credentials.'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }

                            } catch (error) {
                              // Handle network or other errors
                              print('Error during login: $error');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('An error occurred during login. Please try again later.'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      _gap(),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgetPassword(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.black87,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _gap(),
<<<<<<< Updated upstream:agriconnect/lib/login_screen.dart
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black45,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Navigate to ProfilePage1
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage1(),
                            ),
                          );
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _gap(),
=======
>>>>>>> Stashed changes:lib/screens/dashboard/login_screen.dart
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Register(),
                        ),
                      );
                    },
                    child: Text(
                      'Don\'t have an account? Sign up!',
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
<<<<<<< Updated upstream:agriconnect/lib/login_screen.dart
=======

  Future<void> saveUserDetailsToLocal(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('numTel', user.numTel);
      prefs.setString('password', user.password);
    } catch (e) {
      print('Error saving user details to local storage: $e');
    }
  }
>>>>>>> Stashed changes:lib/screens/dashboard/login_screen.dart
}
