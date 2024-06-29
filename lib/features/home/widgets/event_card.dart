import 'package:eventify/config/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            buildEventContainer(context),
          ],
        ),
      ),
    );
  }

  Widget buildEventContainer(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoute.detailsRoute);
      },
      child: Container(
        width: 250,
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0BC),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 100,
              margin: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                image: DecorationImage(
                  image: AssetImage("assets/images/concert.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Text(
                        'Atif Aslam Concert',
                        style: GoogleFonts.libreBaskerville(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        top: 1,
                        left: 1,
                        child: Text(
                          'Atif Aslam Concert',
                          style: GoogleFonts.libreBaskerville(
                              fontStyle: FontStyle.italic,
                              color: const Color(0xFF0C5387),
                              fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/icons/location.png',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'Hyatt Ground, Kathmandu (1st May, 2025)',
                          style: GoogleFonts.libreBaskerville(
                              fontStyle: FontStyle.italic,
                              color: const Color(0xFFFA0F00),
                              fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
