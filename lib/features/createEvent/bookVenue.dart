import 'dart:convert';

import 'package:eventify/config/router/app_router.dart';
import 'package:eventify/core/storage/flutter_secure_storage.dart';
import 'package:eventify/features/home/widgets/bottom_navbar.dart';
import 'package:eventify/features/models/promo_modal.dart';
import 'package:eventify/features/models/promocode.dart';
import 'package:eventify/features/models/venue_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class VenueBookingPage extends StatefulWidget {
  const VenueBookingPage({super.key});

  @override
  State<VenueBookingPage> createState() => _VenueBookingPageState();
}

class _VenueBookingPageState extends State<VenueBookingPage> {
  int _selectedIndex = 0;

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool _isVenueBooked = false;
  String _bookingStatusMessage = '';
  bool _bookingPending = false;

  String? _selectedLocation = "";
  List<dynamic> _locations = [];
  Map<String, dynamic> selectedLocationData = {};
  final List<Venue> _venues = [];

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController _venueNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchLocations(); // Fetch locations when the page initializes
  }

  Future<void> _fetchLocations() async {
    try {
      final token = await SecureStorage().readToken();
      if (token != null) {
        final response = await http.get(
          Uri.parse('http://192.168.68.109:5500/api/venues/locations'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        logger.d('Response status: ${response.statusCode}');
        logger.d('Response body: ${response.body}');

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          logger.d('JSON response: $jsonResponse');

          List<dynamic> fetchedLocations = jsonResponse['locations'];

          // Ensure each location is unique before setting state
          Set<String> uniqueLocations = {};
          for (var location in fetchedLocations) {
            if (!uniqueLocations.contains(location['location'])) {
              uniqueLocations.add(location['location']);
            }
          }

          // Filter out locations with non-unique values
          List<dynamic> filteredLocations = fetchedLocations
              .where(
                  (location) => uniqueLocations.contains(location['location']))
              .toList();

          setState(() {
            _locations = filteredLocations
                .map((location) => location['location'] as String)
                .toList();
          });

          logger.d('Locations fetched successfully: $_locations');
        } else {
          throw Exception('Failed to load locations: ${response.statusCode}');
        }
      } else {
        logger.e('Token is null');
      }
    } catch (e, stackTrace) {
      logger.e('Exception occurred: $e');
      logger.e('Stack trace: $stackTrace');
    }
  }

  void _showLocationSelectionOptions() async {
    try {
      final token = await SecureStorage().readToken();
      if (token != null) {
        final response = await http.get(
          Uri.parse('http://192.168.68.109:5500/api/venues/getVenues'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          logger.d('Fetched venues: $jsonResponse');

          // Access the venues list from the jsonResponse
          final venues = jsonResponse['venues'] as List<dynamic>;
          logger.d('Venues: $venues');

          final selectedLocation = await showModalBottomSheet<String>(
            context: context,
            builder: (context) {
              return ListView.builder(
                itemCount: venues.length,
                itemBuilder: (context, index) {
                  final venue = venues[index] as Map<String, dynamic>;
                  final locationName = venue['location'];

                  return ListTile(
                    title: Text(locationName),
                    onTap: () {
                      logger.d('Selected location: $locationName');

                      // Find the venue data for the selected location
                      final venueData = {
                        'venueName': venue['name'],
                        'image':
                            'http://192.168.68.109:5500/' + venue['images'][0],
                        'price': venue['price'].toString(),
                        'location': locationName,
                      };

                      setState(() {
                        _selectedLocation = locationName;
                        selectedLocationData = venueData;

                        // Update the text fields with the selected venue data
                        _venueNameController.text = venueData['venueName'];
                        _priceController.text = venueData['price'];
                      });

                      Navigator.pop(context, locationName);
                    },
                  );
                },
              );
            },
          );

          if (selectedLocation != null) {
            setState(() {
              _selectedLocation = selectedLocation;
            });
          }
        } else {
          throw Exception('Failed to load venues: ${response.statusCode}');
        }
      } else {
        logger.e('Token is null');
      }
    } catch (e, stackTrace) {
      logger.e('Exception occurred: $e');
      logger.e('Stack trace: $stackTrace');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
        dateController.selection = TextSelection.fromPosition(
          TextPosition(offset: dateController.text.length),
        );
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        timeController.text = picked.format(context);
        timeController.selection = TextSelection.fromPosition(
          TextPosition(offset: timeController.text.length),
        );
      });
    }
  }

  Future<void> _bookVenue() async {
    try {
      final token = await SecureStorage().readToken();
      if (token != null) {
        // Ensure venueName and price are present in selectedLocationData
        if (selectedLocationData.containsKey('venueName') &&
            selectedLocationData.containsKey('price')) {
          final bookingData = {
            'location': _selectedLocation ?? '',
            'venueName': selectedLocationData['venueName'],
            'price': selectedLocationData['price'],
            'date': dateController.text,
            'time': timeController.text,
          };

          logger.d('Booking data: $bookingData');

          final response = await http.post(
            Uri.parse(
                'http://192.168.68.109:5500/api/user/venuebookings/createBooking'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(bookingData),
          );

          logger.d('Response status: ${response.statusCode}');
          logger.d('Response body: ${response.body}');
          logger.d('Response headers: ${response.headers}');

          if (response.statusCode == 200 || response.statusCode == 201) {
            final jsonResponse = jsonDecode(response.body);
            logger.d('Venue booked successfully: $jsonResponse');

            // Show success dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Success'),
                  content: const Text('Venue booked successfully!'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        // Clear data and navigate back
                        _clearVenueData();
                        Navigator.pushReplacementNamed(
                            context, AppRoute.homeRoute);
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            throw Exception(
                'Failed to book venue: ${response.statusCode} - ${response.body}');
          }
        } else {
          throw Exception('Venue data (venueName and/or price) is missing.');
        }
      } else {
        logger.e('Token is null');
      }
    } catch (e) {
      logger.e('Exception occurred: $e');
    }
  }

  void _clearVenueData() {
    setState(() {
      _selectedLocation = '';
      selectedLocationData = {};

      dateController.clear();
      timeController.clear();

      _isVenueBooked = false;
      _bookingPending = false;
      _bookingStatusMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(width: 60),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Location',
                              style: GoogleFonts.libreBaskerville(
                                color: const Color(0xFF031421),
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Dillibazar, Kathmandu',
                              style: GoogleFonts.libreBaskerville(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Choose Location',
                      style: GoogleFonts.libreBaskerville(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(153, 0, 0, 0),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      height: 49,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFF),
                        border: Border.all(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      child: GestureDetector(
                        onTap: _showLocationSelectionOptions,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            color: const Color(0xFFFAFAFF).withOpacity(0.64),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisSize: MainAxisSize
                                .min, // Ensure row takes minimum space needed
                            children: [
                              Expanded(
                                child: Text(
                                  selectedLocationData.isNotEmpty
                                      ? selectedLocationData['location'] ??
                                          'Select a location'
                                      : 'Select a location',
                                  style: selectedLocationData.isNotEmpty
                                      ? GoogleFonts.libreBaskerville(
                                          fontSize: 12,
                                          color: const Color(0xFF172B4D),
                                          fontWeight: FontWeight.bold,
                                        )
                                      : GoogleFonts.libreBaskerville(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Venue Name',
                      style: GoogleFonts.libreBaskerville(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(153, 0, 0, 0),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      height: 49,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFF),
                        border: Border.all(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icons/wedding.png',
                            width: 23,
                            height: 23,
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: TextField(
                              controller: _venueNameController,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.libreBaskerville(
                                fontSize: 12,
                                color: const Color(0xFF172B4D),
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Venue Name',
                                hintStyle: GoogleFonts.libreBaskerville(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date',
                                style: GoogleFonts.libreBaskerville(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0x99232A36),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Container(
                                height: 49,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFAFAFF),
                                  border: Border.all(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(13.0),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Image.asset(
                                        'assets/icons/calendar.png',
                                        height: 23,
                                        width: 23,
                                      ),
                                      onPressed: () => _selectDate(context),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Expanded(
                                      child: TextField(
                                        controller: dateController,
                                        readOnly: true,
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.libreBaskerville(
                                          fontSize: 12,
                                          color: const Color(0xFF172B4D),
                                          fontWeight: FontWeight.bold,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Event Date',
                                          hintStyle:
                                              GoogleFonts.libreBaskerville(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Time',
                                style: GoogleFonts.libreBaskerville(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0x99232A36),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Container(
                                height: 49,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFAFAFF),
                                  border: Border.all(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(13.0),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Image.asset(
                                        'assets/icons/time.png',
                                        height: 23,
                                        width: 23,
                                      ),
                                      onPressed: () => _selectTime(context),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Expanded(
                                      child: TextField(
                                        controller: timeController,
                                        readOnly: true,
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.libreBaskerville(
                                          fontSize: 12,
                                          color: const Color(0xFF172B4D),
                                          fontWeight: FontWeight.bold,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Event Time',
                                          hintStyle:
                                              GoogleFonts.libreBaskerville(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Venue\'s Image:',
                      style: GoogleFonts.libreBaskerville(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF031421),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    SizedBox(
                      height: 200, // Adjust height as per your requirement
                      width: double.infinity, // Takes full width available
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: selectedLocationData['image'] != null
                            ? Image.network(
                                selectedLocationData['image'],
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: Colors.grey,
                                child: const Center(
                                  child: Text('No Image'),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Price',
                                style: GoogleFonts.libreBaskerville(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0x99232A36),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Container(
                                height: 49,
                                width: 165,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFAFAFF),
                                  border: Border.all(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(13.0),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/price.png',
                                      width: 23,
                                      height: 23,
                                    ),
                                    const SizedBox(width: 8.0),
                                    Expanded(
                                      child: TextField(
                                        controller: TextEditingController(
                                          text: selectedLocationData.isNotEmpty
                                              ? selectedLocationData['price'] ??
                                                  ''
                                              : '',
                                        ),
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.libreBaskerville(
                                          fontSize: 12,
                                          color: const Color(0xFF172B4D),
                                          fontWeight: FontWeight.bold,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Price',
                                          hintStyle:
                                              GoogleFonts.libreBaskerville(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Have Promo Code?',
                                style: TextStyle(fontSize: 10),
                              ),
                              const Text(
                                'Use it for exclusive discounts',
                                style: TextStyle(fontSize: 10),
                              ),
                              TextButton(
                                onPressed: () async {
                                  List<PromoCode> promoCodes =
                                      await fetchPromoCodesFromBackend();
                                  showCustomModalSheet(
                                    context: context,
                                    promoCodes: promoCodes,
                                    onApplyPressed: (promoCode) {
                                      print('Promo code applied: $promoCode');
                                    },
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                ),
                                child: const Text(
                                  'Promo Code?',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFFFA0F00),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _bookVenue,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.amber,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 3.0,
                            vertical: 10.0,
                          ),
                          child: Text(
                            'Book Venue',
                            style: GoogleFonts.libreBaskerville(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    if (_isVenueBooked)
                      Center(
                        child: Column(
                          children: [
                            _bookingPending
                                ? Column(
                                    children: [
                                      const CircularProgressIndicator(),
                                      const SizedBox(height: 16.0),
                                      Text(
                                        _bookingStatusMessage,
                                        style: GoogleFonts.libreBaskerville(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 50,
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        _bookingStatusMessage,
                                        style: GoogleFonts.libreBaskerville(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(height: 16.0),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _isVenueBooked = false;
                                            _bookingPending = false;
                                            _bookingStatusMessage = '';
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFFFFF2C5),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 80,
                                            vertical: 14,
                                          ),
                                        ),
                                        child: Text(
                                          'Create Another Event',
                                          style: GoogleFonts.libreBaskerville(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF073767),
                                          ),
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
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
