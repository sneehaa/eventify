import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
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
              height: 570,
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
                    Center(
                      child: Text(
                        'Contact Details',
                        style: GoogleFonts.libreBaskerville(
                          fontSize: 16,
                          color: const Color(0xFF121420),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildContactInfoRow('Contact Name:', 'Esha Aryal'),
                     const SizedBox(height: 10),
                    _buildContactInfoRow('Phone Number:', '+977 9876543210'),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8CC8B0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 2,
                          ),
                        ),
                        child: Text(
                          'Promo Code',
                          style: GoogleFonts.libreBaskerville(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Container(
                       height: 76,
                       width: 365,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0BC),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                             const SizedBox(height: 10),
                            Text(
                              'Rs.5000',
                              style: GoogleFonts.libreBaskerville(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Total Payable Amount',
                              style: GoogleFonts.libreBaskerville(
                                fontSize: 14,
                                color: const Color(0xFF868789),
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Ticket Summary:',
                      style: GoogleFonts.libreBaskerville(
                        fontSize: 14,
                        color: const Color(0xFF4C4D4E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF2EEEE),
                        
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTicketSummaryRow('1 Phase I: General', 'x Rs. 5000', 'Rs.5000'),
                          const SizedBox(height: 10),
                          const Divider(color: Color(0xFFFEF9F9)),
                          _buildTicketSummaryRow('Total Amount:', '', 'Rs. 5000', isTotal: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                        },
                        label: Text(
                          'Pay via',
                          style: GoogleFonts.libreBaskerville(
                            fontSize: 18,
                            color: const Color(0xFF1C1B19),
                          ),
                        ),
                        icon: Image.asset('assets/images/khalti.png', height: 24),
                        
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFC700),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
        ],
      ),
    );
  }

  Widget _buildContactInfoRow(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.libreBaskerville(
                fontSize: 14,
                color: const Color(0x80172B4D),
              ),
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: GoogleFonts.libreBaskerville(
                  fontSize: 14,
                  color: const Color(0xFF121420),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20,),
      Container(
        width: 1500, 
        height: 1,
        color: const Color.fromARGB(255, 200, 200, 201),
      ),
    ],
  );
}


  Widget _buildTicketSummaryRow(String label, String multiplier, String value, {bool isTotal = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Text(
            label,
            style: GoogleFonts.libreBaskerville(
              fontSize: isTotal ? 14 : 14,
              color: isTotal ? const Color(0xFF000000) : const Color(0xFF7E7E7E),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (multiplier.isNotEmpty) ...[
            const SizedBox(width: 10),
            Text(
              multiplier,
              style: GoogleFonts.libreBaskerville(
                fontSize: 14,
                color: const Color(0xFF7E7E7E),
              ),
            ),
          ]
        ],
      ),
      Text(
        value,
        style: GoogleFonts.libreBaskerville(
          fontSize: isTotal ? 14 : 14,
          color: isTotal ? const Color(0xFF000000) : const Color(0xFF7E7E7E),
          fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ],
  );
}
}