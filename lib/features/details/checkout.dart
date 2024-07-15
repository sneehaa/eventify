import 'dart:convert';
import 'dart:developer' as developer;

import 'package:eventify/config/service/user_service.dart';
import 'package:eventify/core/storage/flutter_secure_storage.dart';
import 'package:eventify/features/details/ticket_count.dart';
import 'package:eventify/features/models/promo_modal.dart';
import 'package:eventify/features/models/promocode.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:logger/logger.dart';

class CheckoutPage extends StatefulWidget {
  final Map<String, dynamic> event;
  final TicketCounts ticketCounts;

  const CheckoutPage({
    super.key,
    required this.event,
    required this.ticketCounts,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late UserService userService;
  Map<String, dynamic>? userData;
  String? userId;
  bool isLoading = true;
  String appliedPromoCode = '';
  double promoDiscountPercentage = 0.0;
  String imageUrl = '';

  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    final secureStorage = SecureStorage();
    userService = UserService(
        baseUrl: 'http://192.168.68.109:5500/api/user/profile',
        secureStorage: secureStorage,
        deleteUrl: 'http://192.168.68.109:5500/api/user/delete',
        editUrl: 'http://192.168.68.109:5500/api/user/edit');
    fetchUserId();
    if (widget.event['adminImages'] != null &&
        widget.event['adminImages'].isNotEmpty) {
      imageUrl = widget.event['adminImages'][0]
          .replaceAll('/uploads/uploads/', '/uploads/');
    }
  }

  Future<void> fetchUserId() async {
    try {
      final token = await SecureStorage().readToken();
      if (token != null) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        final id = decodedToken['id'];

        if (id != null) {
          setState(() {
            userId = id;
          });
          fetchUserData(id);
        } else {
          throw Exception('User ID not found in token');
        }
      } else {
        throw Exception('Token not found');
      }
    } catch (e) {
      developer.log('Failed to load user ID: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchUserData(String userId) async {
    try {
      final data = await userService.fetchUserData(userId);
      setState(() {
        userData = data;
        isLoading = false;
      });
    } catch (e) {
      developer.log('Failed to load user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<PromoCode>> fetchPromoCodesFromBackend() async {
    try {
      String? token = await SecureStorage().readToken();
      final url = Uri.parse('http://192.168.68.109:5500/api/promo-codes');
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData != null && jsonData['promoCodes'] != null) {
          // Add null check for jsonData
          List<dynamic> promoCodesJson = jsonData['promoCodes'];
          return promoCodesJson
              .map((code) => PromoCode.fromJson(code))
              .toList();
        } else {
          return []; // Return empty list if promoCodes is null or jsonData is null
        }
      } else {
        throw Exception('Failed to load promo codes');
      }
    } catch (e) {
      developer.log('Error fetching promo codes: $e');
      throw Exception('Error fetching promo codes: $e');
    }
  }

  void applyPromoCode(String promoCode) async {
    try {
      List<PromoCode> promoCodes = await fetchPromoCodesFromBackend();
      PromoCode? selectedPromoCode = promoCodes.firstWhere(
        (code) => code.code == promoCode,
        orElse: () => PromoCode(id: '', code: '', discount: 0),
      );

      if (selectedPromoCode.id.isNotEmpty) {
        // Valid promo code found
        setState(() {
          appliedPromoCode = promoCode;
          promoDiscountPercentage =
              selectedPromoCode.discount / 100; // Ensure this is a double
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Promo code applied successfully')),
        );
      } else {
        // Invalid promo code
        setState(() {
          appliedPromoCode = '';
          promoDiscountPercentage = 0.0;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid promo code')),
        );
      }
    } catch (e) {
      developer.log('Error applying promo code: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to apply promo code')),
      );
    }
  }

  void onSuccess(PaymentSuccessModel success) {
    // payment successful, handle success scenario
    print('Payment successful');
  }

  void onFailure(PaymentFailureModel failure) {
    // payment failed, handle failure scenario
    print('Payment failed');
  }

  void onCancel() {
    // payment cancelled, handle cancel scenario
    print('Payment cancelled');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.event == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    final double totalAmount =
        (widget.ticketCounts.generalTicketCount.toDouble() *
                widget.event['adminGeneralPrice'].toDouble()) +
            (widget.ticketCounts.fanpitTicketCount.toDouble() *
                widget.event['adminFanpitPrice'].toDouble()) +
            (widget.ticketCounts.vipTicketCount.toDouble() *
                widget.event['adminVipPrice'].toDouble());

    final double discountedAmount = totalAmount * promoDiscountPercentage;
    final double payableAmount = totalAmount - discountedAmount;

    double displayedTotalAmount = appliedPromoCode.isNotEmpty
        ? (totalAmount - (totalAmount * promoDiscountPercentage))
        : totalAmount;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 500.0,
                    errorBuilder: (context, error, stackTrace) {
                      _logger.e('Error loading image: $error');
                      return const Placeholder();
                    },
                  )
                : const Placeholder(),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              height: 570.0,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
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
                          fontSize: 16.0,
                          color: const Color(0xFF121420),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    _buildContactInfoRow(
                        'Contact Name', userData?['fullName'] ?? ''),
                    const SizedBox(height: 10.0),
                    const Divider(
                      color: Color.fromARGB(255, 218, 219, 219),
                    ),
                    _buildContactInfoRow(
                        'Phone Number', userData?['phoneNumber'] ?? ''),
                    const SizedBox(height: 10.0),
                    const Divider(
                      color: Color.fromARGB(255, 218, 219, 219),
                    ),
                    const SizedBox(height: 20.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          List<PromoCode> promoCodes =
                              await fetchPromoCodesFromBackend();
                          showCustomModalSheet(
                            context: context,
                            promoCodes: promoCodes,
                            onApplyPressed: applyPromoCode,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8CC8B0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25.0,
                            vertical: 2.0,
                          ),
                        ),
                        child: Text(
                          'Promo Code',
                          style: GoogleFonts.libreBaskerville(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Container(
                        height: 76.0,
                        width: 365.0,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0BC),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 10.0),
                            Text(
                              'Rs. ${payableAmount.toInt()}',
                              style: GoogleFonts.libreBaskerville(
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              'Total Payable Amount',
                              style: GoogleFonts.libreBaskerville(
                                fontSize: 14.0,
                                color: const Color(0xFF868789),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Ticket Summary',
                      style: GoogleFonts.libreBaskerville(
                        fontSize: 18.0,
                        color: const Color(0xFF121420),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      color: const Color(0xFFF2EEEE),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.ticketCounts.generalTicketCount > 0)
                            Column(
                              children: [
                                _buildTicketSummaryRow(
                                  'Phase I: General',
                                  widget.event['adminGeneralPrice'].toDouble(),
                                  widget.ticketCounts.generalTicketCount,
                                ),
                                const SizedBox(height: 16.0),
                                const Divider(
                                  height: 0.5,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ],
                            ),
                          if (widget.ticketCounts.fanpitTicketCount > 0)
                            Column(
                              children: [
                                const SizedBox(height: 16.0),
                                _buildTicketSummaryRow(
                                  'Phase I: Fanpit',
                                  widget.event['adminFanpitPrice'].toDouble(),
                                  widget.ticketCounts.fanpitTicketCount,
                                ),
                                const SizedBox(height: 16.0),
                                const Divider(
                                  height: 0.5,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ],
                            ),
                          if (widget.ticketCounts.vipTicketCount > 0)
                            Column(
                              children: [
                                const SizedBox(height: 16.0),
                                _buildTicketSummaryRow(
                                  'Phase I: VIP',
                                  widget.event['adminVipPrice'].toDouble(),
                                  widget.ticketCounts.vipTicketCount,
                                ),
                                const SizedBox(height: 16.0),
                                const Divider(
                                  height: 0.5,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ],
                            ),
                          if (appliedPromoCode.isNotEmpty)
                            Column(
                              children: [
                                const SizedBox(height: 16.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '$appliedPromoCode:',
                                      style: GoogleFonts.libreBaskerville(
                                        fontSize: 13.0,
                                        color: const Color(0xFF868789),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${totalAmount.toInt()} X ${(promoDiscountPercentage * 100).toInt()}%',
                                      style: GoogleFonts.libreBaskerville(
                                        fontSize: 13.0,
                                        color: const Color(0xFF121420),
                                      ),
                                    ),
                                    Text(
                                      'Rs. ${(totalAmount * promoDiscountPercentage).toInt()}',
                                      style: GoogleFonts.libreBaskerville(
                                        fontSize: 13.0,
                                        color: const Color(0xFF121420),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                                const Divider(
                                  height: 0.5,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ],
                            ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Amount:',
                                style: GoogleFonts.libreBaskerville(
                                  fontSize: 14.0,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Rs. ${displayedTotalAmount.toInt()}',
                                style: GoogleFonts.libreBaskerville(
                                  fontSize: 14.0,
                                  color: const Color(0xFF121420),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          KhaltiScope.of(context).pay(
                            config: PaymentConfig(
                              amount: (displayedTotalAmount * 100)
                                  .toInt(), // Convert rupees to paisa
                              productIdentity:
                                  'EVENT_TICKET_${widget.event['id']}',
                              productName: 'Event Ticket',
                              mobileReadOnly: false,
                            ),
                            preferences: [PaymentPreference.khalti],
                            onSuccess: onSuccess,
                            onFailure: onFailure,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFC700),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 55.0,
                            vertical: 5.0,
                          ),
                        ),
                        child: Text(
                          'Pay via Khalti',
                          style: GoogleFonts.libreBaskerville(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoRow(String label, String value) {
    String displayValue = value.isNotEmpty ? value : '$label not available';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              '$label: ',
              overflow: TextOverflow.clip,
              style: GoogleFonts.libreBaskerville(
                fontSize: 14.0,
                color: const Color(0xFF868789),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              displayValue,
              style: GoogleFonts.libreBaskerville(
                fontSize: 14.0,
                color: const Color(0xFF121420),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketSummaryRow(
    String ticketType,
    double ticketPrice,
    int ticketCount, {
    double discountPercentage = 0,
  }) {
    double totalAmount = ticketPrice * ticketCount;

    if (discountPercentage > 0) {
      double discountAmount = totalAmount * (discountPercentage / 100);
      double discountedTotal = totalAmount - discountAmount;

      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Discount ($appliedPromoCode):',
                style: GoogleFonts.libreBaskerville(
                  fontSize: 14.0,
                  color: const Color(0xFF868789),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '- Rs. ${discountAmount.toInt()}',
                style: GoogleFonts.libreBaskerville(
                  fontSize: 14.0,
                  color: const Color(0xFF121420),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount:',
                style: GoogleFonts.libreBaskerville(
                  fontSize: 14.0,
                  color: const Color(0xFF868789),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Rs. ${discountedTotal.toInt()}',
                style: GoogleFonts.libreBaskerville(
                  fontSize: 14.0,
                  color: const Color(0xFF121420),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: SizedBox(
              height: 20.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ticketType,
                    style: GoogleFonts.libreBaskerville(
                      fontSize: 14.0,
                      color: const Color(0xFF868789),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'x ${discountPercentage.round()}%',
                    style: GoogleFonts.libreBaskerville(
                      fontSize: 14.0,
                      color: const Color(0xFF121420),
                    ),
                  ),
                  Visibility(
                    visible: appliedPromoCode.isNotEmpty,
                    child: Column(
                      children: [
                        Text(
                          'Rs. ${discountedTotal.toInt()}',
                          style: GoogleFonts.libreBaskerville(
                            fontSize: 14.0,
                            color: const Color(0xFF121420),
                          ),
                        ),
                        Text(
                          '(${totalAmount.toInt()} x ${discountPercentage.toInt()}%)',
                          style: GoogleFonts.libreBaskerville(
                            fontSize: 14.0,
                            color: const Color(0xFF121420),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: SizedBox(
          height: 20.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ticketType,
                style: GoogleFonts.libreBaskerville(
                  fontSize: 14.0,
                  color: const Color(0xFF868789),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'x Rs.${ticketPrice.toInt()}',
                style: GoogleFonts.libreBaskerville(
                  fontSize: 14.0,
                  color: const Color.fromARGB(255, 108, 108, 109),
                ),
              ),
              Text(
                'Rs. ${totalAmount.toInt()}',
                style: GoogleFonts.libreBaskerville(
                  fontSize: 14.0,
                  color: const Color(0xFF121420),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
