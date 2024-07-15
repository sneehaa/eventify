import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:eventify/config/router/app_router.dart';
import 'package:eventify/core/storage/flutter_secure_storage.dart';
import 'package:eventify/features/home/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  int _selectedIndex = 0;
  bool isLoading = true;
  bool _showSuccessMessage = false;

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final Logger logger = Logger(printer: PrettyPrinter());

  String? userId;

  List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDateController = TextEditingController();
  final TextEditingController _eventTimeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _ticketPriceController = TextEditingController();

  bool _isEventCreated = false;

  Future<void> _getImageFromGallery() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 80,
      );

      if (pickedFiles.isNotEmpty) {
        setState(() {
          _images = pickedFiles.map((file) => File(file.path)).toList();
        });
      }
    } catch (e) {
      logger.e('Error picking images: $e');
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
            isLoading = false;
          });
          // fetchUserData(id);
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

  Future<void> _createEvent(BuildContext context) async {
    if (_eventNameController.text.isEmpty ||
        _eventDateController.text.isEmpty ||
        _eventTimeController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _ticketPriceController.text.isEmpty ||
        _images.isEmpty) {
      logger.e('Please fill all fields');
      return;
    }

    if (userId == null) {
      await fetchUserId();
    }

    if (userId == null) {
      logger.e('Failed to fetch user ID');
      return;
    }

    try {
      final url = Uri.parse('http://192.168.68.109:5500/api/events/create');
      final token = await SecureStorage().readToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['eventName'] = _eventNameController.text;
      request.fields['eventDate'] = _eventDateController.text;
      request.fields['eventTime'] = _eventTimeController.text;
      request.fields['location'] = _locationController.text;
      request.fields['ticketPrice'] = _ticketPriceController.text;
      request.fields['createdBy'] = userId!;

      for (var i = 0; i < _images.length; i++) {
        final file = _images[i];
        final fileName = basename(file.path);
        final stream = http.ByteStream(Stream.castFrom(file.openRead()));
        final length = await file.length();

        final multipartFile = http.MultipartFile(
          'images',
          stream,
          length,
          filename: fileName,
        );

        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        logger.i('Event created successfully: $responseData');
        setState(() {
          _isEventCreated = true;
          _showSuccessMessage = true;
        });
      } else {
        logger.e('Failed to create event. Status code: ${response.statusCode}');
        logger.e('Response body: ${response.body}');
      }
    } catch (e) {
      logger.e('Error creating event: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _eventDateController.text = DateFormat('yyyy-MM-dd').format(picked);
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
        _eventTimeController.text = picked.format(context);
      });
    }
  }

  Widget _buildImageGrid() {
    if (_images.isNotEmpty) {
      int crossAxisCount = 1;
      if (_images.length == 2) {
        crossAxisCount = 2;
      } else if (_images.length >= 3) {
        crossAxisCount = 3;
      }

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: _images.length,
        itemBuilder: (context, index) {
          return Image.file(
            _images[index],
            fit: BoxFit.fitHeight,
          );
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: const Color(0xFFFFF0BC),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoute.homeRoute);
          },
        ),
        title: Center(
          child: Text(
            'Create Your Event',
            style: GoogleFonts.libreBaskerville(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Implement notification icon action
            },
            icon: Image.asset(
              'assets/icons/notification.png',
              width: 26,
              height: 26,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_isEventCreated)
                GestureDetector(
                  onTap: _getImageFromGallery,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Images:',
                        style: GoogleFonts.libreBaskerville(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Images that best describe your event (Add up to 5 images)',
                        style: GoogleFonts.libreBaskerville(
                          fontSize: 12,
                          color: const Color.fromARGB(128, 14, 27, 48),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Container(
                        height: 240,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: _images.isEmpty
                            ? const Center(
                                child: Icon(
                                  Icons.add_a_photo,
                                  size: 40,
                                ),
                              )
                            : _buildImageGrid(),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16.0),
              if (!_isEventCreated)
                Text(
                  'Event Name',
                  style: GoogleFonts.libreBaskerville(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0x99232A36),
                  ),
                ),
              const SizedBox(height: 8.0),
              if (!_isEventCreated)
                Container(
                  height: 49,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFF),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(13.0),
                  ),
                  child: Row(
                    children: [
                      Image.asset("assets/icons/event.png",
                          width: 23, height: 23),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: TextField(
                          controller: _eventNameController,
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontSize: 12),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Event Name',
                            hintStyle: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16.0),
              if (!_isEventCreated)
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAFAFF),
                              border: Border.all(color: Colors.grey),
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
                                    controller: _eventDateController,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 12),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Event Date',
                                      hintStyle: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16.0),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAFAFF),
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(13.0),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Image.asset(
                                    "assets/icons/time.png",
                                    height: 23,
                                    width: 23,
                                  ),
                                  onPressed: () => _selectTime(context),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _eventTimeController,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 12),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Event Time',
                                      hintStyle: TextStyle(fontSize: 12),
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
              const SizedBox(height: 16.0),
              if (!_isEventCreated)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location',
                            style: GoogleFonts.libreBaskerville(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: const Color(0x99232A36),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Container(
                            height: 49,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAFAFF),
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(13.0),
                            ),
                            child: Row(
                              children: [
                                Image.asset('assets/icons/eventlocation.png',
                                    width: 23, height: 23),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: TextField(
                                    controller: _locationController,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 12),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Location',
                                      hintStyle: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ticket Price',
                            style: GoogleFonts.libreBaskerville(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: const Color(0x99232A36),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Container(
                            height: 49,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAFAFF),
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(13.0),
                            ),
                            child: Row(
                              children: [
                                Image.asset('assets/icons/price.png',
                                    width: 23, height: 23),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: TextField(
                                    controller: _ticketPriceController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 12),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Ticket Price',
                                      hintStyle: TextStyle(fontSize: 12),
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
              const SizedBox(height: 2.0),
              if (!_isEventCreated)
                Row(
                  children: [
                    const Text(
                      'Don\'t have a venue?',
                      style: TextStyle(fontSize: 11),
                    ),
                    const SizedBox(width: 4.0),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoute.venueRoute);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                      ),
                      child: const Text(
                        'Book here!',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFFFA0F00),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 10.0),
              if (!_isEventCreated)
                Center(
                  child: ElevatedButton(
                    onPressed: () => _createEvent(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xFF1C1B19),
                      backgroundColor: const Color(0xFFFFC700),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text(
                      'Add Event',
                      style: GoogleFonts.libreBaskerville(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              if (_isEventCreated && _showSuccessMessage)
                Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 50,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Event created successfully!',
                        style: GoogleFonts.libreBaskerville(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Event Name: ${_eventNameController.text}',
                        style: GoogleFonts.libreBaskerville(
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Date: ${_eventDateController.text}',
                        style: GoogleFonts.libreBaskerville(
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Time: ${_eventTimeController.text}',
                        style: GoogleFonts.libreBaskerville(
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Location: ${_locationController.text}',
                        style: GoogleFonts.libreBaskerville(
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Ticket Price: ${_ticketPriceController.text}',
                        style: GoogleFonts.libreBaskerville(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isEventCreated = false;
                            _showSuccessMessage = false;
                            _eventNameController.clear();
                            _eventDateController.clear();
                            _eventTimeController.clear();
                            _locationController.clear();
                            _ticketPriceController.clear();
                            _images.clear();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFF2C5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
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
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
