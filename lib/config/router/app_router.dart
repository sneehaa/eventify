import 'package:eventify/features/details/details_screen.dart';
import 'package:eventify/features/home/home_screen.dart';
import 'package:eventify/features/login/login.dart';
import 'package:eventify/features/onBoarding/onboarding_screen.dart';
import 'package:eventify/features/signup/signup.dart';
import 'package:eventify/features/splash/splash_screen.dart';

class AppRoute {
  AppRoute._();

  static const String splashRoute = '/';
  static const String locationRoute = '/location';
  static const String onboardingRoute = '/onboarding';
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';
  static const String homeRoute = '/home';
  static const String detailsRoute = '/details';

  static getApplicationRoute() {
    return {
      splashRoute: (context) => const SplashScreen(),
      onboardingRoute: (context) => const OnboardingScreen(),
      loginRoute: (context) => const LoginView(),
      homeRoute: (context) =>  const HomeScreen(),
      signupRoute: (context) => const SignupPage(),
      detailsRoute: (context) => const DetailsPage(),
    };

  }
}