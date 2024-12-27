import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mingalar_music_app/core/constants/image_strings.dart';
import 'package:mingalar_music_app/core/providers/current_playlist_notifier.dart';
import 'package:mingalar_music_app/core/providers/favorite_music_notifier.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/utils.dart';
import 'package:mingalar_music_app/features/home/viewmodel/home_view_model.dart';

class MusicPlayer extends ConsumerStatefulWidget {
  const MusicPlayer({super.key});

  @override
  ConsumerState<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends ConsumerState<MusicPlayer> {
  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoriteMusicNotifierProvider);

    final playlistModels = ref.watch(currentPlaylistNotifierProvider.notifier);
    final currentPlaylist =
        playlistModels.playlists[playlistModels.activePlaylistId];
    final currentTrack = ref.watch(currentPlaylistNotifierProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            hexToColor(currentTrack!.hexCode),
            const Color(0xff121212),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: AppPallete.transparentColor,
        appBar: AppBar(
          backgroundColor: AppPallete.transparentColor,
          leading: Transform.translate(
            offset: const Offset(-15, 0),
            child: InkWell(
              highlightColor: AppPallete.transparentColor,
              focusColor: AppPallete.transparentColor,
              splashColor: AppPallete.transparentColor,
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  iPullDownArrow,
                  color: AppPallete.whiteColor,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Hero(
                  tag: 'music-image',
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: currentTrack.thumbnailUrl.startsWith('https')
                            ? NetworkImage(currentTrack.thumbnailUrl)
                            : FileImage(File(currentTrack.thumbnailUrl)),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentTrack.musicName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
                                color: AppPallete.whiteColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              currentTrack.artist,
                              style: const TextStyle(
                                color: AppPallete.subtitleText,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          favorites.containsKey(currentTrack.id)
                              ? {
                                  ref
                                      .read(favoriteMusicNotifierProvider
                                          .notifier)
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
                                      .read(favoriteMusicNotifierProvider
                                          .notifier)
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
                    ],
                  ),
                  const SizedBox(height: 15),
                  StreamBuilder(
                      stream: currentPlaylist!.audioPlayer.positionStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        }
                        final position = snapshot.data;
                        final duration = currentPlaylist.audioPlayer.duration;
                        double sliderValue = 0.0;
                        if (position != null && duration != null) {
                          sliderValue =
                              position.inMilliseconds / duration.inMilliseconds;
                        }
                        return Column(
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: AppPallete.whiteColor,
                                inactiveTrackColor:
                                    AppPallete.whiteColor.withOpacity(0.117),
                                thumbColor: AppPallete.whiteColor,
                                trackHeight: 4,
                                overlayShape: SliderComponentShape.noOverlay,
                              ),
                              child: Slider(
                                value: sliderValue,
                                min: 0,
                                max: 1,
                                onChanged: (val) {
                                  sliderValue = val;
                                },
                                onChangeEnd: playlistModels.seek,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${position?.inMinutes}:${(position?.inSeconds ?? 0) % 60 < 10 ? '0${(position?.inSeconds ?? 0) % 60}' : (position?.inSeconds ?? 0) % 60}',
                                  style: const TextStyle(
                                    color: AppPallete.subtitleText,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Text(
                                  '${duration?.inMinutes}:${(duration?.inSeconds ?? 0) % 60 < 10 ? '0${(duration?.inSeconds ?? 0) % 60}' : (duration?.inSeconds ?? 0) % 60}',
                                  style: const TextStyle(
                                    color: AppPallete.subtitleText,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onTap: () {
                            ref
                                .watch(currentPlaylistNotifierProvider.notifier)
                                .toggleShuffle();
                            setState(() {});
                          },
                          child: SizedBox(
                            width: 25,
                            height: 25,
                            child: SvgPicture.asset(
                              iShuffleSVG,
                              colorFilter:
                                  currentPlaylist.audioPlayer.shuffleModeEnabled
                                      ? const ColorFilter.mode(
                                          AppPallete.greenColor,
                                          BlendMode.srcIn,
                                        )
                                      : const ColorFilter.mode(
                                          AppPallete.greyColor,
                                          BlendMode.srcIn,
                                        ),
                            ),
                          ),
                        ),
                      ),
                      // const SizedBox(width: 20),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            playlistModels.skipToPrevious();
                          },
                          child: Image.asset(
                            iPreviousSong,
                            color: AppPallete.whiteColor,
                          ),
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
                          currentPlaylist.isPlaying
                              ? CupertinoIcons.pause_circle_fill
                              : CupertinoIcons.play_circle_fill,
                        ),
                        iconSize: 80,
                        color: AppPallete.whiteColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            playlistModels.skipToNext();
                          },
                          child: Image.asset(
                            iNextSong,
                            color: AppPallete.whiteColor,
                          ),
                        ),
                      ),
                      // const SizedBox(width: 20),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          iRepeat,
                          color: AppPallete.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          iConnectDevice,
                          color: AppPallete.whiteColor,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          iPlaylist,
                          color: AppPallete.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
