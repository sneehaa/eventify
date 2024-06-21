import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int _generalTicketCount = 1;
  int _fanpitTicketCount = 1;
  int _vipTicketCount = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Atif Aslam.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 500,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              height: 550,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
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
                        fontSize: 18,
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
                            const Icon(Icons.date_range, color: Colors.black, size: 15,),
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
                            const Icon(Icons.access_time, color: Colors.black, size: 15,),
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
                          width: 15,
                          height: 15,
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
                      width: 380,
                      color: const Color(0xFF7A869A),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'Ticket Prices',
                          style: GoogleFonts.libreBaskerville(
                            fontSize: 12,
                            color: const Color.fromARGB(255, 22, 22, 22),
                          ),
                        ),
                        const SizedBox(width: 40),
                        Text(
                          'Descriptions',
                          style: GoogleFonts.libreBaskerville(
                            fontSize: 12,
                            color: const Color.fromARGB(255, 22, 22, 22),
                          ),
                        ),
                        const SizedBox(width: 40),
                        Text(
                          'Terms & Conditions',
                          style: GoogleFonts.libreBaskerville(
                            fontSize: 12,
                            color: const Color.fromARGB(255, 22, 22, 22),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        height: 1,
                        width: 380,
                        color: const Color(0xFF7A869A),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Select Ticket:',
                      style: GoogleFonts.libreBaskerville(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Phase I',
                          style: GoogleFonts.libreBaskerville(
                            fontSize: 14,
                            color: const Color.fromARGB(255, 36, 36, 36),
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(width: 200),
                        Text(
                          'No.of Tickets',
                          style: GoogleFonts.libreBaskerville(
                            fontSize: 14,
                            color: const Color.fromARGB(255, 36, 36, 36),
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        _buildTicketOption('General', 'Rs. 5,000', _generalTicketCount, (newCount) {
                          setState(() {
                            _generalTicketCount = newCount;
                          });
                        }),
                        _buildTicketOption('Fanpit', 'Rs. 10,000', _fanpitTicketCount, (newCount) {
                          setState(() {
                            _fanpitTicketCount = newCount;
                          });
                        }),
                        _buildTicketOption('VIP', 'Rs. 20,000', _vipTicketCount, (newCount) {
                          setState(() {
                            _vipTicketCount = newCount;
                          });
                        }),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFC700),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )
                        ),
                        child: Text(
                          'Proceed',
                          style: GoogleFonts.libreBaskerville(
                            fontSize: 18,
                            color: const Color(0xFF1C1B19)
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 45,
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
          Positioned(
            top: 20,
            right: -20,
            child: Image.asset(
              'assets/icons/fav.png',
              width: 100,
              height: 100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketOption(String title, String price, int ticketCount, ValueChanged<int> onChanged) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFF),
            borderRadius: BorderRadius.circular(15),
          ),
          width: 170,
          height: 66,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.libreBaskerville(
                  fontSize: 14,
                 color: const Color(0xFF172B4D),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8,),
              Text(
                price,
                style: GoogleFonts.libreBaskerville(
                  fontSize: 12,
                  color: const Color(0xFF585858),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 70),
        Row(
          children: [
            _buildIconButton(Icons.remove, () {
              if (ticketCount > 0) {
                onChanged(ticketCount - 1);
              }
            }),
            const SizedBox(width: 15),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '$ticketCount',
                style: GoogleFonts.libreBaskerville(
                  fontSize: 14,
                  color: const Color(0xFF172B4D),
                ),
              ),
            ),
            const SizedBox(width: 15),
            _buildIconButton(Icons.add, () {
              onChanged(ticketCount + 1);
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 44,
      height: 49,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D1D1)),
        borderRadius: BorderRadius.circular(13),
      ),
      child: IconButton(
        icon: Icon(icon, size: 16, color: const Color(0xFF8CC8B0)),
        onPressed: onPressed,
      ),
    );
  }
}
