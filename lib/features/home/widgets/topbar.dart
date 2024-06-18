import 'package:flutter/material.dart';


class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 132,
      color: const Color(0xFFFFF0BC),
      child:  Stack(
        children: [
          Positioned(
            left: 21,
            top: 62,
            child: Image.asset('assets/icons/search.png', width: 26, height: 26,)
          ),
          Positioned(
            right: 21,
            top: 62,
           child: Image.asset('assets/icons/notification.png', width: 26, height: 26,)
          ),
          const Positioned(
            left: 131,
            top: 62,
            child: Text(
              'Current Location',
              style: TextStyle(
                color: Color(0xFF031421),
                fontSize: 16,
              ),
            ),
          ),
          const Positioned(
            left: 126,
            top: 87,
            child: Text(
              'Dillibazar, Kathmandu',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
