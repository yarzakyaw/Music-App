import 'package:flutter/material.dart';

class ShareOptionModel {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  ShareOptionModel({
    required this.title,
    required this.icon,
    required this.onPressed,
  });
}
