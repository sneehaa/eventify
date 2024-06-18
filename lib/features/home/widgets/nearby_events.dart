import 'package:flutter/material.dart';
import 'package:eventify/features/home/widgets/event_card.dart';

class NearbyEvents extends StatelessWidget {
  const NearbyEvents({super.key});

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
                child: const Text('See all', style: TextStyle(
                  fontSize: 14,
                ),)
                ,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                EventCard(),
                EventCard(),
                EventCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
