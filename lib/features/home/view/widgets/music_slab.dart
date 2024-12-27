import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mingalar_music_app/core/providers/current_music_notifier.dart';
import 'package:mingalar_music_app/core/providers/current_playlist_notifier.dart';
import 'package:mingalar_music_app/core/providers/favorite_music_notifier.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/utils.dart';
import 'package:mingalar_music_app/features/home/view/widgets/music_player.dart';
import 'package:mingalar_music_app/features/home/viewmodel/home_view_model.dart';

class MusicSlab extends ConsumerStatefulWidget {
  const MusicSlab({super.key});

  @override
  ConsumerState<MusicSlab> createState() => _MusicSlabState();
}

class _MusicSlabState extends ConsumerState<MusicSlab> {
  @override
  Widget build(BuildContext context) {
    // final currentMusic = ref.watch(currentMusicNotifierProvider);
    // final musicNotifier = ref.read(currentMusicNotifierProvider.notifier);
    final favorites = ref.watch(favoriteMusicNotifierProvider);
    final playlistModels = ref.watch(currentPlaylistNotifierProvider.notifier);

    // final currentTrack = playlistModels.getCurrentTrack();
    final currentTrack = ref.watch(currentPlaylistNotifierProvider);
    final currentPlaylist =
        playlistModels.playlists[playlistModels.activePlaylistId];

    if (currentTrack == null) {
      return const SizedBox();
    }

    debugPrint('currentTrack URL: ${currentTrack.thumbnailUrl}');

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return const MusicPlayer();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              final tween =
                  Tween(begin: const Offset(0, 1), end: Offset.zero).chain(
                CurveTween(curve: Curves.easeIn),
              );

              final offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      },
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: 66,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: hexToColor(currentTrack.hexCode),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.all(9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Hero(
                        tag: 'music-image',
                        child: Container(
                          width: 48,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: currentTrack.thumbnailUrl
                                      .startsWith('https')
                                  ? NetworkImage(currentTrack.thumbnailUrl)
                                  : FileImage(File(currentTrack.thumbnailUrl)),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              currentTrack.musicName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              currentTrack.artist,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppPallete.subtitleText,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        favorites.containsKey(currentTrack.id)
                            ? {
                                ref
                                    .read(
                                        favoriteMusicNotifierProvider.notifier)
                                    .removeFromFavorites(currentTrack.id),
                                ref
                                    .read(homeViewModelProvider.notifier)
                                    .updateFavoriteStatusToFirebase(
                                      isLiked: false,
                                      track: currentTrack,
                                    )
                              }
                            : {
                                ref
                                    .read(
                                        favoriteMusicNotifierProvider.notifier)
                                    .addToFavorite(currentTrack),
                                ref
                                    .read(homeViewModelProvider.notifier)
                                    .updateFavoriteStatusToFirebase(
                                      isLiked: true,
                                      track: currentTrack,
                                    )
                              };
                      },
                      icon: Icon(
                        favorites.containsKey(currentTrack.id)
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart,
                        color: AppPallete.subtitleText,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        playlistModels.togglePlayPause();
                        setState(() {});
                        // if (musicNotifier.isPlaying) {
                        //   ref
                        //       .read(homeViewModelProvider.notifier)
                        //       .updatePlayStatusToFirebase(
                        //         track: currentMusic,
                        //       );
                        // }
                      },
                      icon: Icon(
                        currentPlaylist!.isPlaying
                            ? CupertinoIcons.pause_fill
                            : CupertinoIcons.play_fill,
                        color: AppPallete.subtitleText,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          StreamBuilder(
            stream: currentPlaylist.audioPlayer.positionStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }
              final position = snapshot.data;
              final duration = currentPlaylist.audioPlayer.duration;
              double sliderValue = 0.0;
              if (position != null && duration != null) {
                sliderValue = position.inMilliseconds / duration.inMilliseconds;
              }

              return Positioned(
                bottom: 0,
                left: 8,
                child: Container(
                  height: 2,
                  width: sliderValue * (MediaQuery.of(context).size.width - 18),
                  decoration: BoxDecoration(
                    color: AppPallete.gradient1,
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 8,
            child: Container(
              height: 2,
              width: MediaQuery.of(context).size.width - 18,
              decoration: BoxDecoration(
                color: AppPallete.inactiveSeekColor,
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
