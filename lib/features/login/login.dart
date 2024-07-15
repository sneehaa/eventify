import 'dart:convert';

import 'package:eventify/config/constants/api_endpoints.dart';
import 'package:eventify/config/router/app_router.dart';
import 'package:eventify/core/snackbar/snackbar.dart'; // Import your custom snackbar utility
import 'package:eventify/core/storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Import Geolocator package
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _passwordVisible = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey;

  final SecureStorage secureStorage = SecureStorage();

  @override
  void initState() {
    super.initState();
    _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
    _requestPermissions(); // Request location permission on init
  }

  Future<void> _requestPermissions() async {
    print('Requesting permissions...');
    await _requestLocationPermission(); // Request location permission
  }

  Future<void> _requestLocationPermission() async {
    print('Requesting location permission...');
    LocationPermission permission = await Geolocator.requestPermission();
    print('Location permission status: $permission');
    if (permission == LocationPermission.denied) {
      showSnackBar(
        message: 'Location permission denied',
        context: context,
      );
    } else if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _setInitialCameraPosition(); // Proceed to set initial camera position
    }
  }

  Future<void> _setInitialCameraPosition() async {
    try {
      Position currentPosition = await Geolocator.getCurrentPosition();
      print('Current position: $currentPosition');
      // Use the current position to set initial camera position or perform other actions
      setState(() {
        // Set your state variables based on the current position if needed
      });
    } catch (e) {
      print('Error getting current location: $e');
      showSnackBar(
        message: 'Error getting current location: $e',
        context: context,
      );
    }
  }

  Future<void> _login() async {
    final url = Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.login);
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'username': _usernameController.text.trim(),
      'password': _passwordController.text.trim(),
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData != null && responseData['token'] != null) {
          final token = responseData['token'] as String;
          await secureStorage.writeToken(token);

          // Check location permission
          LocationPermission permission = await Geolocator.checkPermission();
          print('Location permission status during login: $permission');
          if (permission == LocationPermission.denied) {
            // Request location permission
            await _requestLocationPermission();
          } else if (permission == LocationPermission.whileInUse ||
              permission == LocationPermission.always) {
            // Navigate to home page
            Navigator.pushNamed(context, AppRoute.homeRoute);

            // Show snackbar
            showSnackBar(
              message: 'Login successful',
              context: context,
            );
          }
        } else {
          // Handle unexpected response format
          print('Invalid response format from server');
          showSnackBar(
            message: 'Login failed: Invalid response',
            context: context,
          );
        }
      } else if (response.statusCode == 401) {
        // Handle unauthorized access (e.g., incorrect password)
        print('Login failed: Unauthorized access');
        showSnackBar(
          message: 'Login failed: Incorrect password or username',
          context: context,
        );
      } else if (response.statusCode == 404) {
        // Handle user not found
        print('Login failed: User not found');
        showSnackBar(
          message: 'Login failed: User does not exist',
          context: context,
        );
      } else {
        // Handle non-200 status codes
        print('Login failed. Status code: ${response.statusCode}');
        showSnackBar(
          message: 'Login failed',
          context: context,
        );
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Error during login: $e');
      showSnackBar(
        message: 'Error: $e',
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    width: 370,
                    height: 370,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/splash_screen.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(right: 200),
                  child: Text(
                    'Login',
                    style: GoogleFonts.libreBaskerville(fontSize: 25),
                  ),
                ),
                const SizedBox(height: 30),
                _buildTextField(
                  iconPath: 'assets/icons/user.png',
                  hintText: 'Username',
                  controller: _usernameController,
                ),
                const SizedBox(height: 40),
                _buildTextField(
                  iconPath: 'assets/icons/password.png',
                  hintText: 'Password',
                  obscureText: !_passwordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                  controller: _passwordController,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 149,
                  height: 37,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC806),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: GoogleFonts.libreBaskerville(
                          fontSize: 25, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 21),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't Have an Account? ",
                      style: GoogleFonts.libreBaskerville(
                        fontSize: 17,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoute.signupRoute);
                      },
                      child: Text(
                        'Signup',
                        style: GoogleFonts.libreBaskerville(
                          color: const Color(0xFFF56B62),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Forgot your password? ",
                      style: GoogleFonts.libreBaskerville(
                        fontSize: 15,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, AppRoute.forgotPasswordRoute);
                      },
                      child: Text(
                        'Reset',
                        style: GoogleFonts.libreBaskerville(
                          fontSize: 15,
                          color: const Color(0xFFF56B62),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String iconPath,
    required String hintText,
    bool obscureText = false,
    Widget? suffixIcon,
    required TextEditingController controller,
  }) {
    return Container(
      width: 319,
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0BC),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            width: 24,
            height: 24,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ),
          if (suffixIcon != null) suffixIcon,
        ],
      ),
    );
  }
}
