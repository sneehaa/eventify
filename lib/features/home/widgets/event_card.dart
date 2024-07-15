import 'dart:convert';

import 'package:eventify/features/details/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EventCard extends StatefulWidget {
  const EventCard({super.key});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  Future<List<Map<String, dynamic>>> fetchEvents() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.68.109:5500/api/admin/events/getAll'),
      );

      if (response.statusCode == 200) {
        List<dynamic> events = json.decode(response.body)['events'];
        Set<String> eventIds = {}; // Use a set to track unique event IDs
        List<Map<String, dynamic>> formattedEvents = [];

        for (var event in events) {
          String eventId = event['_id'];
          String eventName = event['adminEventName'];
          String eventDateTime = event['adminEventDate'];
          DateTime? parsedDate = DateTime.tryParse(eventDateTime);

          if (parsedDate != null) {
            String formattedDate = _formatDate(parsedDate);

            if (eventIds.add(eventId)) {
              // Check if the event ID is added to the set
              formattedEvents.add({
                'id': eventId,
                'adminEventName': eventName,
                'adminLocation': event['adminLocation'] ?? '',
                'adminEventDate': formattedDate,
                'image': event['adminImages']?.isNotEmpty == true
                    ? event['adminImages'][0]
                            ?.replaceAll('/uploads/uploads/', '/uploads/') ??
                        ''
                    : '',
              });
            }
          } else {
            print('Unable to parse date: $eventDateTime');
          }
        }

        return formattedEvents;
      } else {
        throw Exception('Failed to load events');
      }
    } catch (error) {
      print('Error fetching events: $error');
      rethrow;
    }
  }

  String _formatDate(DateTime eventDate) {
    String day = DateFormat.d().format(eventDate); // Day of the month
    String suffix =
        _getDaySuffix(int.parse(day)); // Get ordinal suffix for the day
    String monthYear = DateFormat.yMMM().format(eventDate); // Month and year

    return '($day$suffix $monthYear)';
  }

  // Function to get the ordinal suffix for the day (e.g., 1st, 2nd, 3rd, ...)
  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No events available'));
        } else {
          List<Map<String, dynamic>> events = snapshot.data!;

          return SizedBox(
            height: 200,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: events.map((eventData) {
                  return buildEventContainer(context, eventData);
                }).toList(),
              ),
            ),
          );
        }
      },
    );
  }

  Widget buildEventContainer(
      BuildContext context, Map<String, dynamic> eventData) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(eventId: eventData['id']),
          ),
        );
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
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  eventData['image'],
                  fit: BoxFit.cover,
                  width: 200,
                  height: 100,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading image: $error');
                    return Container(
                      color: Colors.grey.withOpacity(0.3),
                      width: 200,
                      height: 100,
                      child: const Icon(Icons.error),
                    );
                  },
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
                        eventData['adminEventName'],
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
                          eventData['adminEventName'],
                          style: GoogleFonts.libreBaskerville(
                            fontStyle: FontStyle.italic,
                            color: const Color(0xFF0C5387),
                            fontSize: 16,
                          ),
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
                          '${eventData['adminLocation']} ${eventData['adminEventDate']}',
                          style: GoogleFonts.libreBaskerville(
                            fontStyle: FontStyle.italic,
                            color: const Color(0xFFFA0F00),
                            fontSize: 10,
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
    );
  }
}
