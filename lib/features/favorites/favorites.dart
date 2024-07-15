import 'dart:convert';

import 'package:eventify/config/router/app_router.dart';
import 'package:eventify/core/storage/flutter_secure_storage.dart';
import 'package:eventify/features/home/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> favorites = [];
  bool isLoading = true;
  int _selectedIndex = 0;

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> fetchFavorites() async {
    try {
      final token = await SecureStorage().readToken();
      final response = await http.get(
        Uri.parse('http://192.168.68.109:5500/api/favorites/getFavorites'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('Response data: $jsonData');

        if (jsonData is Map<String, dynamic> &&
            jsonData.containsKey('favorites')) {
          setState(() {
            favorites = List<Map<String, dynamic>>.from(jsonData['favorites']);
            isLoading = false;
          });
        } else if (jsonData is List<dynamic>) {
          setState(() {
            favorites = jsonData.map((e) => e as Map<String, dynamic>).toList();
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          throw Exception('Unexpected data format');
        }
      } else {
        setState(() {
          isLoading = false;
        });
        print(
            'Failed to load favorites: ${response.statusCode}'); // Debugging line
        throw Exception('Failed to load favorites');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching favorites: $e'); // Debugging line
    }
  }

  void removeFavorite(int index) async {
    final item = favorites[index];
    final eventId =
        item['eventId']['_id']; // Ensure this extracts the eventId correctly

    try {
      final token = await SecureStorage().readToken();
      final url = Uri.parse(
          'http://192.168.68.109:5500/api/favorites/removeFavorite/$eventId');

      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          favorites.removeAt(index); // Remove item from local list
        });
        print('Favorite successfully removed');
      } else {
        print('Failed to remove favorite: ${response.statusCode}');
        // Handle error if needed
      }
    } catch (e) {
      print('Error removing favorite: $e');
      // Handle error
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoute.homeRoute);
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favorites.isNotEmpty
              ? ListView.builder(
                  itemCount: favorites.length + 1, // +1 for the Buy Tickets row
                  itemBuilder: (context, index) {
                    if (index < favorites.length) {
                      return _buildFavoriteItem(index);
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Buy Tickets?',
                              style: TextStyle(fontSize: 11),
                            ),
                            const SizedBox(width: 4.0),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, AppRoute.venueRoute);
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                              ),
                              child: const Text(
                                'Proceed!',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFFFA0F00),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                )
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Your Favorites Are Empty!',
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'When you add favorites, they’ll appear here.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildFavoriteItem(int index) {
    final item = favorites[index];
    final event = item['eventId'];
    String imageUrl = '';

    if (event['adminImages'] != null && event['adminImages'].isNotEmpty) {
      // Assuming you need to prepend the base URL to the image path
      imageUrl = 'http://192.168.68.109:5500/${event['adminImages'][0]}';
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        height: 170,
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: SizedBox(
                  width: 106,
                  height: 106,
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image),
                ),
              ),
              const SizedBox(width: 16), // Spacing
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event['adminEventName'] ?? 'Event Name',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rs ${event['adminGeneralPrice'] ?? 0}',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tickets:',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Container(
                      width: 30.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0BC),
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.favorite,
                          size: 16.0,
                          color: Color(0xFFFFC806),
                        ),
                        onPressed: () {
                          removeFavorite(index);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildIconButton(Icons.remove, () {}),
                  const SizedBox(width: 8),
                  const Text(
                    '1',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildIconButton(Icons.add, () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: const Color(0xFFEEF1F4),
        border: Border.all(color: const Color(0xFFEEF1F4)),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20.0, color: const Color(0xFF000000)),
        onPressed: onPressed,
      ),
    );
  }
}
