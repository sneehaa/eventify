import 'package:eventify/config/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for TextInputFormatter
import 'package:google_fonts/google_fonts.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _passwordVisible = false;

  // Input formatter to allow only digits
  final _phoneNumberFormatter = FilteringTextInputFormatter.digitsOnly;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/splash_screen.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 200),
                child: Text(
                  'Signup',
                  style: GoogleFonts.libreBaskerville(fontSize: 25),
                ),
              ),
              const SizedBox(height: 30),
              _buildTextField(
                iconPath: 'assets/icons/user.png',
                hintText: 'Full Name',
              ),
              const SizedBox(height: 20), 
              _buildTextField(
                iconPath: 'assets/icons/user.png',
                hintText: 'Username',
              ),
              const SizedBox(height: 20), 
              _buildTextField(
                iconPath: 'assets/icons/phone.png',
                hintText: 'Phone Number',
                inputFormatters: [_phoneNumberFormatter], 
              ),
              const SizedBox(height: 20),
              _buildTextField(
                iconPath: 'assets/icons/password.png',
                hintText: 'Password',
                obscureText: !_passwordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                iconPath: 'assets/icons/password.png',
                hintText: 'Confirm Password',
                obscureText: !_passwordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 149,
                height: 37,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoute.homeRoute);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC806),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Signup',
                    style: GoogleFonts.libreBaskerville(fontSize: 25, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 21),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: GoogleFonts.libreBaskerville(
                      fontSize: 17,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoute.loginRoute);
                    },
                    child: Text(
                      'Login',
                      style: GoogleFonts.libreBaskerville(
                        color: const Color(0xFFF56B62),
                        fontSize: 20,
                        
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String iconPath,
    required String hintText,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters, // Added inputFormatters parameter
    Widget? suffixIcon,
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
              obscureText: obscureText,
              inputFormatters: inputFormatters, 
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
