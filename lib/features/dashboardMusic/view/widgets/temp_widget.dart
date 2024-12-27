import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';

class TempWidget extends StatelessWidget {
  final AsyncValue<List<MusicModel>> playlist;
  final String title;
  const TempWidget({
    super.key,
    required this.playlist,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Temp'),
    );
  }
}
