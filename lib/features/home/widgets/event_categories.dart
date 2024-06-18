import 'package:flutter/material.dart';

class EventCategories extends StatelessWidget {
  const EventCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Event Categories',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CategoryChip(
                  label: 'Music',
                  color: Color(0xFFE0F1FD),
                  iconPath: 'assets/icons/music.png',
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF0C5387),
                  ),
                ),
                CategoryChip(
                  label: 'Movies',
                  color: Color(0xFFF56B62),
                  iconPath: 'assets/icons/movie.png',
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFF56B62),
                  ),
                ),
                CategoryChip(
                  label: 'Sports',
                  color: Color(0xFF298DD6),
                  iconPath: 'assets/icons/sports.png',
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF298DD6),
                  ),
                ),
                CategoryChip(
                  label: 'Comedy',
                  color: Color(0xFFFFC700),
                  iconPath: 'assets/icons/comedy.png',
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFFC700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final Color color;
  final String iconPath;
  final TextStyle? labelStyle;

  const CategoryChip({
    super.key,
    required this.label,
    required this.color,
    required this.iconPath,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Row(
          children: [
            Image.asset(
              iconPath,
              color: label == 'Music' ? const Color(0xFF0C5387) : color,
              width: 16,
              height: 16,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: labelStyle ??
                  TextStyle(
                    fontSize: 12,
                    color: label == 'Music' ? const Color(0xFF0C5387) : color,
                  ),
            ),
          ],
        ),
        backgroundColor: label == 'Music' ? color : null,
        shape: label == 'Music'
            ? const StadiumBorder(side: BorderSide.none)
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: color),
              ),
      ),
    );
  }
}
