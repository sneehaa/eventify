import 'package:eventify/core/app.dart';
import 'package:eventify/features/home/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => BottomNavBarModel(),
      child: const App(),
    ),
  );
}
