import 'package:flutter/material.dart';
import 'package:mingalar_music_app/core/utils.dart';

class CardWidget extends StatelessWidget {
  final String title;

  const CardWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    // Generate random gradient colors
    final gradientColors = [
      generateRandomColor(),
      generateRandomColor(),
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          // Placeholder image
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: double.infinity,
              height: 150,
              color: Colors.grey[700], // Placeholder color
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Title overlay
          Positioned(
            bottom: 10,
            left: 10,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
