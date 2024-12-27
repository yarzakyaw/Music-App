import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';

class InactiveTrackWidget extends StatelessWidget {
  const InactiveTrackWidget({
    super.key,
    required this.track,
  });

  final MusicModel track;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        title: Text(
          track.musicName,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(track.artist),
        leading: Container(
          width: 56,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: track.thumbnailUrl.startsWith('https')
                  ? NetworkImage(track.thumbnailUrl)
                  : FileImage(File(track.thumbnailUrl)) as ImageProvider,
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              bottomLeft: Radius.circular(4),
            ),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            // More options action
          },
        ),
      ),
    );
  }
}
