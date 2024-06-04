import 'package:eventify/features/onBoarding/onboarding_screen.dart';
import 'package:eventify/features/splash/splash_screen.dart';

class AppRoute {
  AppRoute._();

  static const String splashRoute = '/';
  static const String locationRoute = '/location';
  static const String onboardingRoute = '/onboarding';
  static const String loginRoute = '/login';

  static getApplicationRoute() {
    return {
      splashRoute: (context) => const SplashScreen(),
      // locationRoute: (context) => const LocationPermissionView(),
      onboardingRoute: (context) => const OnboardingScreen(),
      // loginRoute: (context) => const LoginView(),
    };
  }
}