import 'package:eventify/config/router/app_router.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 10,
            top: 174,
            width: 408,
            height: 292,
            child: Image.asset("assets/images/onboarding.png"),
          ),
          const Positioned(
            left: 19,
            top: 573,
            width: 393,
            height: 59,
            child: Text(
              'Discover, Create, Attend - Turn your event ideas into unforgettable experiences',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Positioned(
            left: -8,
            top: 791,
            width: 446,
            height: 141,
            child: Container(
              color: const Color(0xFFFFF0BC),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 20),
                  Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      color: const Color(0xFF8CC8B0),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFF8CC8B0),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF8CC8B0),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8), 
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color:  Color(0xFF8CC8B0),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 277,
            top: 826,
            width: 115,
            height: 42,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoute.homeRoute);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC700),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }
}
