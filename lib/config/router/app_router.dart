import 'package:eventify/features/createEvent/bookVenue.dart';
import 'package:eventify/features/createEvent/create_event.dart';
import 'package:eventify/features/createEvent/myevents.dart';
import 'package:eventify/features/details/checkout.dart';
import 'package:eventify/features/details/details_screen.dart';
import 'package:eventify/features/details/ticket_count.dart';
import 'package:eventify/features/favorites/favorites.dart';
import 'package:eventify/features/forgotPassword/forgot_password.dart';
import 'package:eventify/features/forgotPassword/new_password.dart';
import 'package:eventify/features/forgotPassword/verify_otp.dart';
import 'package:eventify/features/home/home_screen.dart';
import 'package:eventify/features/login/login.dart';
import 'package:eventify/features/notifications/notifications.dart';
import 'package:eventify/features/onBoarding/onboarding_screen.dart';
import 'package:eventify/features/profile/edit_profile.dart';
import 'package:eventify/features/profile/user_profile.dart';
import 'package:eventify/features/signup/signup.dart';
import 'package:eventify/features/splash/splash_screen.dart';

class AppRoute {
  AppRoute._();

  static const String splashRoute = '/';
  static const String locationRoute = '/location';
  static const String onboardingRoute = '/onboarding';
  static const String loginRoute = '/login';
  static const String signupRoute = '/register';
  static const String homeRoute = '/home';
  static const String detailsRoute = '/details';
  static const String checkoutRoute = '/checkout';
  static const String profileRoute = '/profile';
  static const String editProfileRoute = '/editProfile';
  static const String favoriteRoute = '/favorite';
  static const String createRoute = '/create';
  static const String venueRoute = '/bookvenue';
  static const String forgotPasswordRoute = '/forgotPassword';
  static const String verifyOtpRoute = '/verifyOtp';
  static const String createNewPasswordRoute = '/createNewPassword';
  static const String myeventsRoute = '/myevents';
  static const String notificationRoute = '/notification';

  static getApplicationRoute() {
    return {
      splashRoute: (context) => const SplashScreen(),
      onboardingRoute: (context) => const OnboardingScreen(),
      loginRoute: (context) => const LoginView(),
      homeRoute: (context) => const HomeScreen(),
      signupRoute: (context) => const SignupPage(),
      detailsRoute: (context) => const DetailsPage(
            eventId: '',
          ),
      checkoutRoute: (context) => CheckoutPage(
            event: const {},
            ticketCounts: TicketCounts(),
          ),
      profileRoute: (context) => const UserProfile(),
      editProfileRoute: (context) => const EditProfilePage(),
      favoriteRoute: (context) => const FavoritesPage(),
      createRoute: (context) => const CreateEventPage(),
      venueRoute: (context) => const VenueBookingPage(),
      forgotPasswordRoute: (context) => const ForgotPasswordPage(),
      verifyOtpRoute: (context) => const VerifyOtpPage(),
      createNewPasswordRoute: (context) => const NewPasswordPage(),
      myeventsRoute: (context) => const MyEventsPage(),
      notificationRoute: (context) => const NotificationsPage(),
    };
  }
}
