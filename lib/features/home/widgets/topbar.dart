import 'package:eventify/config/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  String currentLocation = 'Fetching location...';

  @override
  void initState() {
    super.initState();
    fetchLocation();
  }

  Future<void> fetchLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        currentLocation = 'Location services are disabled.';
      });
      return;
    }

    // Check permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          currentLocation = 'Location permissions are denied.';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        currentLocation =
            'Location permissions are permanently denied, we cannot request permissions.';
      });
      return;
    }

    // Fetch position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Fetch location name
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark placemark = placemarks[0];
    String placeName = placemark.name ?? '';
    String capitalCity = placemark.administrativeArea ?? '';

    setState(() {
      currentLocation = '$placeName, $capitalCity';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 132,
      color: const Color(0xFFFFF0BC),
      child: Stack(
        children: [
          Positioned(
            left: 21,
            top: 62,
            child: GestureDetector(
              onTap: () {},
              child: Image.asset(
                'assets/icons/search.png',
                width: 26,
                height: 26,
              ),
            ),
          ),
          Positioned(
            right: 21,
            top: 62,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, AppRoute.notificationRoute);
              },
              child: Image.asset(
                'assets/icons/notification.png',
                width: 26,
                height: 26,
              ),
            ),
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
          Positioned(
            left: 126,
            top: 87,
            child: Text(
              currentLocation,
              style: const TextStyle(
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
