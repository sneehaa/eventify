import 'package:eventify/config/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  static const Color selectedColor = Color(0xFFFFC806);
  static const Color unselectedColor = Color.fromRGBO(128, 128, 128, 1);

  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavBarModel>(
      builder: (context, model, child) {
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
                  isSelected: model.selectedIndex == 0,
                  onTap: () {
                    model.selectItem(0);
                    Navigator.pushReplacementNamed(context, AppRoute.homeRoute);
                  },
                ),
                _buildBottomNavigationBarItem(
                  iconPath: 'assets/icons/add.png',
                  label: 'Create',
                  index: 1,
                  isSelected: model.selectedIndex == 1,
                  onTap: () {
                    model.selectItem(1);
                    Navigator.pushReplacementNamed(
                        context, AppRoute.createRoute);
                  },
                ),
                _buildBottomNavigationBarItem(
                  iconPath: 'assets/icons/favorite.png',
                  label: 'Favorites',
                  index: 2,
                  isSelected: model.selectedIndex == 2,
                  onTap: () {
                    model.selectItem(2);
                    Navigator.pushReplacementNamed(
                        context, AppRoute.favoriteRoute);
                  },
                ),
                _buildBottomNavigationBarItem(
                  iconPath: 'assets/icons/profile.png',
                  label: 'Profile',
                  index: 3,
                  isSelected: model.selectedIndex == 3,
                  onTap: () {
                    model.selectItem(3);
                    Navigator.pushReplacementNamed(
                        context, AppRoute.profileRoute);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBarItem({
    required String iconPath,
    required String label,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    double iconSize = isSelected ? 18.0 : 21.0;
    double textSize = isSelected ? 10.0 : 12.0;

    return GestureDetector(
      onTap: onTap,
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

class BottomNavBarModel with ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void selectItem(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
