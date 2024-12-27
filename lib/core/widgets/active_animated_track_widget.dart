import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';

class ActiveAnimatedTrackWidget extends StatelessWidget {
  const ActiveAnimatedTrackWidget({
    super.key,
    required this.track,
    required this.durationInMilliseconds,
  });

  final MusicModel track;
  final int durationInMilliseconds;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: durationInMilliseconds),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
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
                  : FileImage(File(track.thumbnailUrl)),
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
