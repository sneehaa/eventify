import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 435,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavigationBarItem(
              iconPath: 'assets/icons/homepage.png',
              label: 'Home',
              index: 0,
            ),
            _buildBottomNavigationBarItem(
              iconPath: 'assets/icons/add.png',
              label: 'Create',
              index: 1,
            ),
            _buildBottomNavigationBarItem(
              iconPath: 'assets/icons/favorite.png',
              label: 'Favorites',
              index: 2,
            ),
            _buildBottomNavigationBarItem(
              iconPath: 'assets/icons/profile.png',
              label: 'Profile',
              index: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBarItem({
  required String iconPath,
  required String label,
  required int index,
}) {
  bool isSelected = _selectedIndex == index;
  double iconSize = isSelected ? 18.0 : 21.0;
  double textSize = isSelected ? 10.0 : 12.0;

  return GestureDetector(
    onTap: () => _onItemTapped(index),
    child: Container(
      width: isSelected ? 110 : 70,
      height: 36,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFC806) : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            width: iconSize,
            height: iconSize,
            color: isSelected ? Colors.white : const Color.fromRGBO(128, 128, 128, 1),
          ),
          if (isSelected)
            const SizedBox(width: 8),
          if (isSelected)
            Text(
              label,
              style: GoogleFonts.libreBaskerville(
                fontSize: textSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
        ],
      ),
    ),
  );
}
}