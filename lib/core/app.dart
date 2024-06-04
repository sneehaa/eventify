import 'package:eventify/config/router/app_router.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Eventify',
        theme: ThemeData(
          fontFamily: 'LibreBaskerville',
        ),
        initialRoute: AppRoute.splashRoute,
        routes: AppRoute.getApplicationRoute(),
      ),
    );
  }
}
