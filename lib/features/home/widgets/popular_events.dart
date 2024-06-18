import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PopularEvents extends StatelessWidget {
  const PopularEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Events',
                style: GoogleFonts.libreBaskerville(
                  fontSize: 18,
                 
                ),
              ),
              GestureDetector(
                onTap: () {
                
                },
                child: Text(
                  'See all',
                  style: GoogleFonts.libreBaskerville(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 250, 
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildPopularEventItem(
                    'assets/images/popular_event1.jpg',
                    'Arijit Singh Concert',
                    'June 10, 2025',
                    'Hyatt Ground, Kathmandu',
                    'Rs.5000',
                    '10 June'),
                _buildPopularEventItem(
                    'assets/images/popular_event2.jpg',
                    'Anuv Jain',
                    'July 15, 2025',
                    'Gokarna Forest Resort',
                    'Rs.3000',
                    '15 July'),
                _buildPopularEventItem(
                    'assets/images/popular_event3.jpg',
                    'Pratik Kuhad',
                    'August 15, 2025',
                    'Soaltee Hotel',
                    'Rs.4000',
                    '15 Aug'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularEventItem(String imagePath, String title, String date, String location, String price, String dayMonth) {
    return Container(
      width: 320,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.libreBaskerville(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    date,
                    style: GoogleFonts.libreBaskerville(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    location,
                    style: GoogleFonts.libreBaskerville(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    price,
                    style: GoogleFonts.libreBaskerville(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                dayMonth,
                style:GoogleFonts.libreBaskerville(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
