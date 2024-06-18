import 'package:eventify/config/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _passwordVisible = false;

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
                
              ),
              const SizedBox(height: 40),
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
                    'Login',
                    style: GoogleFonts.libreBaskerville(fontSize: 25, color: Colors.black),
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
                       Navigator.pushNamed(context, AppRoute.signupRoute
                       );
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
                      Navigator.pushNamed(context, AppRoute.homeRoute);
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
    );
  }

  Widget _buildTextField({
  required String iconPath,
  required String hintText,
  bool obscureText = false,
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
          width: 24, // Adjust the width of the image
          height: 24, // Adjust the height of the image
          color: const Color.fromARGB(255, 0, 0, 0), // Adjust the color if needed
        ),
        SizedBox(width: 12), // Add spacing between icon and text field
        Expanded(
          child: TextFormField(
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