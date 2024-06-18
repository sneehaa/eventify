import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background Image
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/Atif Aslam.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.7,
              ),
            ),
            // Container with concert details
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(24.0),
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Atif Aslam Concert',
                        style: GoogleFonts.libreBaskerville(
                          fontSize: 24,
                          color: const Color(0xFF0C5387),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.date_range, color: Colors.black),
                              const SizedBox(width: 4),
                              Text(
                                '1st May, 2025',
                                style: GoogleFonts.libreBaskerville(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.access_time, color: Colors.black),
                              const SizedBox(width: 4),
                              Text(
                                '4 PM Onwards',
                                style: GoogleFonts.libreBaskerville(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/location.png',
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Hyatt Ground, Kathmandu',
                            style: GoogleFonts.libreBaskerville(
                              fontSize: 12,
                              color: const Color(0xFFFA0F00),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 1,
                        width: 352,
                        color: const Color(0xFF7A869A),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'Ticket Prices',
                            style: GoogleFonts.libreBaskerville(
                              fontSize: 11,
                              color: const Color(0xFF4C4D4E),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Descriptions',
                            style: GoogleFonts.libreBaskerville(
                              fontSize: 11,
                              color: const Color(0xFF4C4D4E),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Terms & Conditions',
                            style: GoogleFonts.libreBaskerville(
                              fontSize: 11,
                              color: const Color(0xFF4C4D4E),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Select Ticket:',
                        style: GoogleFonts.libreBaskerville(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Ticket options
                      Column(
                        children: [
                          // General Ticket
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF7A869A),
),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'General',
                                  style: GoogleFonts.libreBaskerville(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Rs. 50,000',
                                  style: GoogleFonts.libreBaskerville(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Fanpit Ticket
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF7A869A),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Fanpit',
                                  style: GoogleFonts.libreBaskerville(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Rs. 10,000',
                                  style: GoogleFonts.libreBaskerville(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // VIP Ticket
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF7A869A),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'VIP',
                                  style: GoogleFonts.libreBaskerville(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Rs. 20,000',
                                  style: GoogleFonts.libreBaskerville(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Proceed',
                          style: GoogleFonts.libreBaskerville(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Back Button
            Positioned(
              top: 24,
              left: 24,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            // Favorite Icon
            Positioned(
              top: -5,
              right: -20,
              child: Image.asset(
                'assets/icons/fav.png',
                width: 100,
                height: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}