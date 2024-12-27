import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mingalar_music_app/core/constants/image_strings.dart';
import 'package:mingalar_music_app/core/models/custom_playlist_model.dart';
import 'package:mingalar_music_app/core/providers/all_dhamma_playlists_notifier.dart';
import 'package:mingalar_music_app/core/providers/all_music_playlists_notifier.dart';
import 'package:mingalar_music_app/core/providers/current_playlist_notifier.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/widgets/active_animated_track_widget.dart';
import 'package:mingalar_music_app/core/widgets/inactive_track_widget.dart';
import 'package:mingalar_music_app/features/download/view/screens/download_screen.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';

class MusicListPlaylistWidget extends ConsumerStatefulWidget {
  final List<MusicModel> playlist;
  final String title;
  final CustomPlaylistModel? customRecentPlaylist;

  const MusicListPlaylistWidget({
    super.key,
    required this.playlist,
    required this.title,
    this.customRecentPlaylist,
  });

  @override
  ConsumerState<MusicListPlaylistWidget> createState() =>
      _MusicListPlaylistWidgetState();
}

class _MusicListPlaylistWidgetState
    extends ConsumerState<MusicListPlaylistWidget> {
  void toggleShuffle() {
    setState(() {
      ref.watch(currentPlaylistNotifierProvider.notifier).toggleShuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    final playlistModels = ref.watch(currentPlaylistNotifierProvider.notifier);
    final currentPlaylist =
        playlistModels.playlists[playlistModels.activePlaylistId];
    final shuffleEnabled = currentPlaylist == null
        ? false
        : currentPlaylist.audioPlayer.shuffleModeEnabled;
    ref.watch(currentPlaylistNotifierProvider);
    ref.watch(allMusicPlaylistsNotifierProvider);
    ref.watch(allDhammaPlaylistsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Find in ${widget.title}',
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return DownloadScreen(
                                playlist: widget.playlist,
                                playlistTitle: widget.title,
                              );
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              final tween = Tween(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero)
                                  .chain(
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
                      icon: const Icon(
                        Icons.download_for_offline,
                        size: 35,
                        color: AppPallete.greyColor,
                      ),
                    ),
                    Text('${widget.playlist.length} track(s)'),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        toggleShuffle();
                      },
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: SvgPicture.asset(
                          iShuffleSVG,
                          colorFilter: shuffleEnabled
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
                    IconButton(
                      onPressed: () {
                        if (!playlistModels.playlists
                                .containsKey(widget.title) &&
                            widget.playlist.isNotEmpty) {
                          playlistModels.initializePlaylist(
                            widget.title,
                            widget.title,
                            widget.playlist,
                          );
                        }
                        playlistModels.setCurrentPlaylist(widget.title);
                        playlistModels.playCurrentPlaylist();

                        if (widget.customRecentPlaylist != null) {
                          widget.customRecentPlaylist!.playListType == 'Music'
                              ? ref
                                  .read(allMusicPlaylistsNotifierProvider
                                      .notifier)
                                  .addToPlaylists(widget.customRecentPlaylist!)
                              : ref
                                  .read(allDhammaPlaylistsNotifierProvider
                                      .notifier)
                                  .addToPlaylists(widget.customRecentPlaylist!);
                        }
                      },
                      icon: Icon(
                        playlistModels.playlists[widget.title]?.isPlaying ==
                                true
                            ? CupertinoIcons.pause_circle_fill
                            : CupertinoIcons.play_circle_fill,
                      ),
                      iconSize: 60,
                      color:
                          playlistModels.playlists[widget.title]?.isPlaying ==
                                  true
                              ? AppPallete.greenColor
                              : AppPallete.greyColor,
                    ),
                  ],
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Divider(indent: 30, endIndent: 30, thickness: 3),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.playlist.length,
                itemBuilder: (context, index) {
                  final track = widget.playlist[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        // musicNotifier.updateMusic(track);
                        // homeNotifier.updatePlayStatusToFirebase(
                        //   track: track,
                        // );
                      },
                      child: track.id ==
                              playlistModels
                                  .playlists[widget.title]?.currentTrack?.id
                          ? ActiveAnimatedTrackWidget(
                              track: track,
                              // durationInMilliseconds: currentPlaylist!
                              //     .audioPlayer.duration!.inMilliseconds,
                              durationInMilliseconds: 250,
                            )
                          : InactiveTrackWidget(track: track),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 380)
          ],
        ),
      ),
    );
  }
}


/* import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mingalar_music_app/core/constants/image_strings.dart';
import 'package:mingalar_music_app/core/models/custom_playlist_model.dart';
import 'package:mingalar_music_app/core/providers/all_dhamma_playlists_notifier.dart';
import 'package:mingalar_music_app/core/providers/all_music_playlists_notifier.dart';
import 'package:mingalar_music_app/core/providers/current_playlist_notifier.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/widgets/active_animated_track_widget.dart';
import 'package:mingalar_music_app/core/widgets/inactive_track_widget.dart';
import 'package:mingalar_music_app/features/download/view/screens/download_screen.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';

class MusicListPlaylistWidget extends ConsumerStatefulWidget {
  final List<MusicModel> playlist;
  final String title;
  final CustomPlaylistModel? customRecentPlaylist;

  const MusicListPlaylistWidget({
    super.key,
    required this.playlist,
    required this.title,
    this.customRecentPlaylist,
  });

  @override
  ConsumerState<MusicListPlaylistWidget> createState() =>
      _MusicListPlaylistWidgetState();
}

class _MusicListPlaylistWidgetState
    extends ConsumerState<MusicListPlaylistWidget> {
  bool shuffle = false;

  void toggleShuffle() {
    setState(() {
      shuffle = !shuffle;
      ref.watch(currentPlaylistNotifierProvider.notifier).toggleShuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    final playlistModels = ref.watch(currentPlaylistNotifierProvider.notifier);
    ref.watch(currentPlaylistNotifierProvider);
    ref.watch(allMusicPlaylistsNotifierProvider);
    ref.watch(allDhammaPlaylistsNotifierProvider);

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Find in ${widget.title}',
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return DownloadScreen(
                                playlist: widget.playlist,
                                playlistTitle: widget.title,
                              );
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              final tween = Tween(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero)
                                  .chain(
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
                      icon: const Icon(
                        Icons.download_for_offline,
                        size: 35,
                        color: AppPallete.greyColor,
                      ),
                    ),
                    Text('${widget.playlist.length} track(s)'),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        toggleShuffle();
                      },
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: SvgPicture.asset(
                          iShuffleSVG,
                          colorFilter: shuffle
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
                    IconButton(
                      onPressed: () {
                        if (!playlistModels.playlists
                                .containsKey(widget.title) &&
                            widget.playlist.isNotEmpty) {
                          playlistModels.initializePlaylist(
                            widget.title,
                            widget.title,
                            widget.playlist,
                          );
                        }
                        playlistModels.setCurrentPlaylist(widget.title);
                        playlistModels.playCurrentPlaylist();

                        if (widget.customRecentPlaylist != null) {
                          widget.customRecentPlaylist!.playListType == 'Music'
                              ? ref
                                  .read(allMusicPlaylistsNotifierProvider
                                      .notifier)
                                  .addToPlaylists(widget.customRecentPlaylist!)
                              : ref
                                  .read(allDhammaPlaylistsNotifierProvider
                                      .notifier)
                                  .addToPlaylists(widget.customRecentPlaylist!);
                        }
                      },
                      icon: Icon(
                        playlistModels.playlists[widget.title]?.isPlaying ==
                                true
                            ? CupertinoIcons.pause_circle_fill
                            : CupertinoIcons.play_circle_fill,
                      ),
                      iconSize: 60,
                      color:
                          playlistModels.playlists[widget.title]?.isPlaying ==
                                  true
                              ? AppPallete.greenColor
                              : AppPallete.greyColor,
                    ),
                  ],
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Divider(indent: 30, endIndent: 30, thickness: 3),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppPallete.whiteColor),
                ),
                child: const ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  title: Text('Add more tracks'),
                  leading: SizedBox(
                    width: 56,
                    child: Icon(Icons.add, size: 40),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 0),
              child: SizedBox(
                // height: (130 * widget.playlist.length).toDouble(),
                height: 390,
                child: ListView.builder(
                  itemCount: widget.playlist.length,
                  itemBuilder: (context, index) {
                    final track = widget.playlist[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          // musicNotifier.updateMusic(track);
                          // homeNotifier.updatePlayStatusToFirebase(
                          //   track: track,
                          // );
                        },
                        child: track.id ==
                                playlistModels
                                    .playlists[widget.title]?.currentTrack?.id
                            ? ActiveAnimatedTrackWidget(
                                track: track,
                                // durationInMilliseconds: currentPlaylist!
                                //     .audioPlayer.duration!.inMilliseconds,
                                durationInMilliseconds: 250,
                              )
                            : InactiveTrackWidget(track: track),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 380)
          ],
        ),
      ),
    );
  }
} */
