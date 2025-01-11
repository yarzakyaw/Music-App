import 'package:flutter/material.dart';

class ChartIconWidget extends StatelessWidget {
  final List<Color> colors;
  final String title;
  final String subTitle;

  const ChartIconWidget(
      {super.key,
      required this.colors,
      required this.title,
      required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        gradient: LinearGradient(
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const Divider(indent: 10, endIndent: 10),
          Text(
            subTitle,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
