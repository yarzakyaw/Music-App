import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/utils.dart';
import 'package:mingalar_music_app/core/widgets/loader.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';

class PlaylistCompilationIconWidget extends ConsumerWidget {
  final String title;
  final AsyncValue<List<MusicModel>> asyncTracks;

  const PlaylistCompilationIconWidget({
    super.key,
    required this.title,
    required this.asyncTracks,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gradientColors = [
      generateRandomColor(),
      generateRandomColor(),
    ];

    return asyncTracks.when(
        data: (tracks) {
          List<String> imageUrls =
              tracks.map((track) => track.thumbnailUrl).toList();
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              width: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Left image
                  Positioned(
                    left: 0,
                    child: ClipOval(
                      child: Image.network(
                        imageUrls[0],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Right image
                  Positioned(
                    right: 0, // Adjust this value for more or less overlap
                    child: ClipOval(
                      child: Image.network(
                        imageUrls[2],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Center image (enlarged)
                  ClipOval(
                    child: Image.network(
                      imageUrls[1],
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Title text
                  Positioned(
                    bottom: 5,
                    child: Container(
                      width: 150,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                  )
                  /* for (int i = 0; i < imageUrls.length; i++)
                    Positioned(
                      left: i * 30.0, // Adjust spacing
                      child: ClipOval(
                        child: Image.network(
                          imageUrls[i],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  // Title text
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      color: Colors.black38,
                      child: Text(
                        customPlaylist.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ), */
                ],
              ),
            ),
          );
        },
        error: (error, st) {
          return Center(
            child: Text(
              error.toString(),
            ),
          );
        },
        loading: () => const Loader());
  }
}
