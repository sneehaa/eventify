class AppRoute {
  AppRoute._();

  static const String splashRoute = '/';
  static const String locationRoute = '/location';
  static const String onboardingRoute = '/onboarding';
  static const String loginRoute = '/login';

  static getApplicationRoute() {
    return {
      // splashRoute: (context) => const SplashView(),
      // locationRoute: (context) => const LocationPermissionView(),
      // onboardingRoute: (context) => const OnboardingView(),
      // loginRoute: (context) => const LoginView(),
    };
  }
}