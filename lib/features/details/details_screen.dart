import 'dart:convert';

import 'package:eventify/core/storage/flutter_secure_storage.dart';
import 'package:eventify/features/details/checkout.dart';
import 'package:eventify/features/details/ticket_count.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class DetailsPage extends StatefulWidget {
  final String eventId;

  const DetailsPage({super.key, required this.eventId});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  String? eventId;
  late Future<Map<String, dynamic>?> _eventDetails;
  bool _isFavorite = false;
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    if (widget.eventId.isNotEmpty) {
      _eventDetails = fetchEventDetails(widget.eventId);
    } else {
      _eventDetails = Future.value(null);
    }
  }

  Future<Map<String, dynamic>?> fetchEventDetails(String eventId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.68.109:5500/api/admin/events/${widget.eventId}'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        _logger.d('Event with ID ${widget.eventId} not found.');
        return null;
      } else {
        throw Exception('Failed to load event details: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Error fetching event details: $e');
      return null;
    }
  }

  void _onFavoritePressed() async {
    final token = await SecureStorage().readToken();

    if (token == null) {
      // Handle the case where the token is null
      _logger.e('Token is null');
      return;
    }

    try {
      await toggleFavorite(); // Call the toggleFavorite method
    } catch (e) {
      _logger.e('Error toggling favorite: $e');
    }
  }

  Future<void> toggleFavorite() async {
    const url = 'http://192.168.68.109:5500/api/favorites/toggleFavorite';
    final token = await SecureStorage().readToken();

    if (token == null) {
      // Handle the case where the token is null
      _logger.e('Token is null');
      return;
    }

    final requestBody = jsonEncode({'eventId': widget.eventId});
    _logger.d('Request body: $requestBody');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: requestBody,
    );

    _logger.d('Response status code: ${response.statusCode}');
    _logger.d('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['error'] != null) {
        // Handle the error returned by the server
        _logger.e('Failed to toggle favorite status: ${data['error']}');
      } else {
        _logger.d('Toggled favorite status successfully. Updating UI...');
        setState(() {
          _isFavorite = !_isFavorite; // Update the _isFavorite state
        });
        _logger.d('UI updated successfully.');

        _showSuccessAlert();
      }
    } else {
      _logger.e('Failed to toggle favorite status: ${response.body}');
    }
  }

  void _showSuccessAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Success',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Added to Favorites',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Color(0xFF1C1B19),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments is String) {
      eventId = arguments;
    } else {
      print('Error: arguments is not a string');
    }
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => TicketCounts(),
        child: _buildDetailsPageUI(),
      ),
    );
  }

  Widget _buildDetailsPageUI() {
    return _eventDetails != null
        ? FutureBuilder<Map<String, dynamic>?>(
            future: _eventDetails,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                var event = snapshot.data!['event'];
                return _buildEventDetails(context, event);
              } else if (snapshot.hasError) {
                _logger.e('Error loading event details: ${snapshot.error}');
                return _buildDefaultUI();
              }
              return _buildLoadingUI();
            },
          )
        : _buildDefaultUI();
  }

  Widget _buildEventDetails(BuildContext context, Map<String, dynamic> event) {
    String imageUrl = '';

    if (event['adminImages'] != null && event['adminImages'].isNotEmpty) {
      imageUrl =
          event['adminImages'][0].replaceAll('/uploads/uploads/', '/uploads/');
    }

    DateTime eventDate = DateTime.parse(event['adminEventDate']);
    String formattedDate = DateFormat('d MMM, yyyy').format(eventDate);

    final ticketCounts = context.watch<TicketCounts>();

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
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              height: 570.0,
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
                      event['adminEventName'],
                      style: GoogleFonts.libreBaskerville(
                        fontSize: 18,
                        color: const Color(0xFF0C5387),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.date_range,
                              color: Colors.black,
                              size: 15.0,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              formattedDate,
                              style: GoogleFonts.libreBaskerville(
                                fontSize: 12.0,
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: Colors.black,
                              size: 15.0,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              event['adminEventTime'],
                              style: GoogleFonts.libreBaskerville(
                                fontSize: 12.0,
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/location.png',
                          width: 15.0,
                          height: 15.0,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          event['adminLocation'],
                          style: GoogleFonts.libreBaskerville(
                            fontSize: 12.0,
                            color: const Color(0xFFFA0F00),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      height: 1.0,
                      width: 380.0,
                      color: const Color(0xFF7A869A),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Ticket Prices',
                            style: GoogleFonts.libreBaskerville(
                              fontSize: 12.0,
                              color: const Color.fromARGB(255, 22, 22, 22),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Descriptions',
                            style: GoogleFonts.libreBaskerville(
                              fontSize: 12.0,
                              color: const Color.fromARGB(255, 22, 22, 22),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Terms & Conditions',
                            style: GoogleFonts.libreBaskerville(
                              fontSize: 12.0,
                              color: const Color.fromARGB(255, 22, 22, 22),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        height: 1.0,
                        width: 380.0,
                        color: const Color(0xFF7A869A),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Select Ticket:',
                      style: GoogleFonts.libreBaskerville(
                        fontSize: 13.0,
                        color: const Color(0xFF4C4D4E),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Text(
                          'Phase I',
                          style: GoogleFonts.libreBaskerville(
                            fontSize: 13.0,
                            color: const Color(0xFF4C4D4E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'No.of Tickets',
                          style: GoogleFonts.libreBaskerville(
                            fontSize: 13.0,
                            color: const Color(0xFF4C4D4E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Column(
                      children: [
                        _buildTicketOption(
                          'General',
                          'Rs. ${event['adminGeneralPrice'].toDouble()}',
                          ticketCounts.generalTicketCount,
                          (newCount) {
                            ticketCounts.updateTicketCounts(
                              generalTickets: newCount,
                              fanpitTickets: ticketCounts.fanpitTicketCount,
                              vipTickets: ticketCounts.vipTicketCount,
                            );
                          },
                        ),
                        _buildTicketOption(
                          'Fanpit',
                          'Rs. ${event['adminFanpitPrice'].toDouble()}',
                          ticketCounts.fanpitTicketCount,
                          (newCount) {
                            ticketCounts.updateTicketCounts(
                              generalTickets: ticketCounts.generalTicketCount,
                              fanpitTickets: newCount,
                              vipTickets: ticketCounts.vipTicketCount,
                            );
                          },
                        ),
                        _buildTicketOption(
                          'VIP',
                          'Rs. ${event['adminVipPrice'].toDouble()}',
                          ticketCounts.vipTicketCount,
                          (newCount) {
                            ticketCounts.updateTicketCounts(
                              generalTickets: ticketCounts.generalTicketCount,
                              fanpitTickets: ticketCounts.fanpitTicketCount,
                              vipTickets: newCount,
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          final ticketCounts = context.read<TicketCounts>();
                          if (ticketCounts.generalTicketCount == 0 &&
                              ticketCounts.fanpitTicketCount == 0 &&
                              ticketCounts.vipTicketCount == 0) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'No Tickets Selected',
                                    style: GoogleFonts.libreBaskerville(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: Text(
                                    'Please select at least one ticket.',
                                    style: GoogleFonts.libreBaskerville(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'OK',
                                        style: GoogleFonts.libreBaskerville(
                                          fontSize: 16.0,
                                          color: const Color(0xFF1C1B19),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutPage(
                                  event: event,
                                  ticketCounts: ticketCounts,
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFC700),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text(
                          'Proceed',
                          style: GoogleFonts.libreBaskerville(
                            fontSize: 18.0,
                            color: const Color(0xFF1C1B19),
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
            top: 45.0,
            left: 24.0,
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
            top: 20.0,
            right: -20.0,
            child: IconButton(
              onPressed: _onFavoritePressed,
              icon: Image.asset(
                _isFavorite ? 'assets/icons/fav.png' : 'assets/icons/fav.png',
                width: 100.0,
                height: 100.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildTicketOption(
    String title, String price, int ticketCount, ValueChanged<int> onChanged) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Expanded(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFF),
              borderRadius: BorderRadius.circular(15.0),
            ),
            height: 66.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.libreBaskerville(
                    fontSize: 14.0,
                    color: const Color(0xFF172B4D),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  price,
                  style: GoogleFonts.libreBaskerville(
                    fontSize: 12.0,
                    color: const Color(0xFF585858),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        Row(
          children: [
            _buildIconButton(Icons.remove, () {
              if (ticketCount > 0) {
                onChanged(ticketCount - 1);
              }
            }),
            const SizedBox(width: 8.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '$ticketCount',
                style: GoogleFonts.libreBaskerville(
                  fontSize: 14.0,
                  color: const Color(0xFF172B4D),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            _buildIconButton(Icons.add, () {
              onChanged(ticketCount + 1);
            }),
          ],
        ),
      ],
    ),
  );
}

Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
  return Container(
    width: 44.0,
    height: 49.0,
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xFFD1D1D1)),
      borderRadius: BorderRadius.circular(13.0),
    ),
    child: IconButton(
      icon: Icon(icon, size: 16.0, color: const Color(0xFF8CC8B0)),
      onPressed: onPressed,
    ),
  );
}

Widget _buildDefaultUI() {
  return const Center(
    child: Text('No event details available.'),
  );
}

Widget _buildLoadingUI() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}
