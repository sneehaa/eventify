import 'package:eventify/features/home/widgets/bottom_navbar.dart';
import 'package:eventify/features/home/widgets/event_categories.dart';
import 'package:eventify/features/home/widgets/invite_banner.dart';
import 'package:eventify/features/home/widgets/nearby_events.dart';
import 'package:eventify/features/home/widgets/popular_events.dart';
import 'package:eventify/features/home/widgets/topbar.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopBar(),
            EventCategories(),
            NearbyEvents(),
            SizedBox(height: 15,),
            InviteBanner(),
             SizedBox(height: 15,),
            PopularEvents(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(), 
    );
  }
}
