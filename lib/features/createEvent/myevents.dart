import 'package:eventify/config/router/app_router.dart';
import 'package:eventify/config/service/user_service.dart';
import 'package:eventify/core/storage/flutter_secure_storage.dart';
import 'package:eventify/features/models/event_models.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class MyEventsPage extends StatefulWidget {
  const MyEventsPage({Key? key}) : super(key: key);

  @override
  State<MyEventsPage> createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  late UserService userService;
  List<Event> userEvents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    userService = UserService(
      baseUrl: 'http://192.168.68.109:5500/api',
      deleteUrl: 'http://192.168.68.109:5500/api/user/delete',
      editUrl: 'http://192.168.68.109:5500/api/user/edit',
      secureStorage: SecureStorage(),
    );
    fetchUserEvents();
  }

  Future<void> fetchUserEvents() async {
    try {
      final token = await SecureStorage().readToken();
      if (token != null) {
        final decodedToken = JwtDecoder.decode(token);
        final userId = decodedToken['id'] as String?;
        if (userId != null && userId.isNotEmpty) {
          final events = await userService.fetchUserEvents(userId);
          setState(() {
            userEvents = events;
            isLoading = false;
          });
        } else {
          throw Exception('User ID not found in token');
        }
      } else {
        throw Exception('Token not found');
      }
    } catch (e) {
      print('Failed to fetch user events: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Events',
          style: GoogleFonts.libreBaskerville(fontSize: 20),
        ),
        toolbarHeight: 100,
        backgroundColor: const Color(0xFFFFF0BC),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoute.profileRoute);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: userEvents.length,
              itemBuilder: (context, index) {
                final event = userEvents[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.name,
                          style: GoogleFonts.libreBaskerville(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 14),
                            const SizedBox(width: 5),
                            Text(
                              'Date: ${event.date.year}-${event.date.month}-${event.date.day}',
                              style: GoogleFonts.libreBaskerville(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 14),
                            const SizedBox(width: 5),
                            Text(
                              'Time: ${event.time}',
                              style: GoogleFonts.libreBaskerville(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14),
                            const SizedBox(width: 5),
                            Text(
                              'Location: ${event.location}',
                              style: GoogleFonts.libreBaskerville(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.attach_money, size: 14),
                            const SizedBox(width: 5),
                            Text(
                              'Ticket Price: Rs.${event.ticketPrice}',
                              style: GoogleFonts.libreBaskerville(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (event.images.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              'http://192.168.68.109:5500/${event.images.first}',
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
