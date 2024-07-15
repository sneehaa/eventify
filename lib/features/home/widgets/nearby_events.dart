import 'dart:convert';

import 'package:eventify/features/home/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NearbyEvents extends StatefulWidget {
  const NearbyEvents({Key? key}) : super(key: key);

  @override
  _NearbyEventsState createState() => _NearbyEventsState();
}

class _NearbyEventsState extends State<NearbyEvents> {
  List<dynamic> events = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.68.109:5500/api/admin/events/getAll'));
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['events'] is List) {
          setState(() {
            events = responseData['events'];
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

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
              const Text(
                'Nearby Events',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'See all',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : events.isEmpty
                    ? Center(child: Text('No events available'))
                    : Row(
                        children:
                            events.map<Widget>((event) => EventCard()).toList(),
                      ),
          ),
        ],
      ),
    );
  }
}
