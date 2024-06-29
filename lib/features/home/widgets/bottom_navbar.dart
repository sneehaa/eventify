import 'package:eventify/config/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final void Function(int) onItemSelected;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  static const Color selectedColor = Color(0xFFFFC806);
  static const Color unselectedColor = Color.fromRGBO(128, 128, 128, 1);

  void _onItemTapped(int index) {
    if (widget.selectedIndex != index) {
      widget.onItemSelected(index);
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, AppRoute.homeRoute);
          break;
        case 1:
          Navigator.pushReplacementNamed(context, AppRoute.createRoute);
          break;
        case 2:
          Navigator.pushReplacementNamed(context, AppRoute.favoriteRoute);
          break;
        case 3:
          Navigator.pushReplacementNamed(context, AppRoute.profileRoute);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
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
    bool isSelected = widget.selectedIndex == index;
    double iconSize = isSelected ? 18.0 : 21.0;
    double textSize = isSelected ? 10.0 : 12.0;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        width: isSelected ? 110 : 70,
        height: 36,
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: iconSize,
              height: iconSize,
              color: isSelected ? Colors.white : unselectedColor,
              semanticLabel: label,
            ),
            if (isSelected) const SizedBox(width: 8),
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
