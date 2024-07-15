import 'package:eventify/config/router/app_router.dart';
import 'package:eventify/features/details/ticket_count.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      publicKey: "test_public_key_242aa7bbaf1742539c8a51ee00aba0e2",
      enabledDebugging: true,
      builder: (context, navKey) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => TicketCounts()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Eventify',
            theme: ThemeData(
              textTheme: GoogleFonts.libreBaskervilleTextTheme(
                Theme.of(context).textTheme,
              ).copyWith(
                bodyLarge: GoogleFonts.libreBaskerville(),
                bodyMedium: GoogleFonts.libreBaskerville(),
              ),
            ),
            localizationsDelegates: const [
              KhaltiLocalizations.delegate,
            ],
            initialRoute: AppRoute.splashRoute,
            routes: AppRoute.getApplicationRoute(),
            navigatorKey: navKey,
          ),
        );
      },
    );
  }
}
