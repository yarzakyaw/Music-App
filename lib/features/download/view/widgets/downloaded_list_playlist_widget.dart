import 'dart:convert';
import 'dart:io';

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
import 'package:mingalar_music_app/features/home/models/music_model.dart';
import 'package:path_provider/path_provider.dart';

class DownloadedListPlaylistWidget extends ConsumerStatefulWidget {
  //final Directory storedPath;
  final String folderName;

  const DownloadedListPlaylistWidget({
    super.key,
    required this.folderName,
  });

  @override
  ConsumerState<DownloadedListPlaylistWidget> createState() =>
      _DownloadedListPlaylistWidgetState();
}

class _DownloadedListPlaylistWidgetState
    extends ConsumerState<DownloadedListPlaylistWidget> {
  late Future<List<MusicModel>> _musicFilesFuture;

  Future<List<MusicModel>> _getDownloadedFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final dirPath = '${directory.path}/${widget.folderName}';
    final dir = Directory(dirPath);
    final files = dir.listSync().whereType<File>().toList();

    debugPrint(wrapWidth: 1024, 'Stored Path: ${dir.path}');

    List<MusicModel> musicModels = [];

    for (var file in files) {
      if (file.path.endsWith('.json')) {
        final metadata = await file.readAsString();
        final musicModelFirebase = MusicModel.fromJson(jsonDecode(metadata));
        final musicModel = MusicModel.fromJson(jsonDecode(metadata)).copyWith(
          musicUrl: '${dir.path}/${musicModelFirebase.musicName}.mp3',
          thumbnailUrl: '${dir.path}/${musicModelFirebase.musicName}.jpg',
        );
        musicModels.add(musicModel);
      }
    }

    return musicModels;
  }

  bool shuffle = false;

  void toggleShuffle() {
    setState(() {
      shuffle = !shuffle;
      ref.watch(currentPlaylistNotifierProvider.notifier).toggleShuffle();
    });
  }

  @override
  void initState() {
    super.initState();
    _musicFilesFuture = _getDownloadedFiles();
  }

  @override
  Widget build(BuildContext context) {
    final playlistModels = ref.watch(currentPlaylistNotifierProvider.notifier);
    ref.watch(currentPlaylistNotifierProvider);
    ref.watch(allMusicPlaylistsNotifierProvider);
    ref.watch(allDhammaPlaylistsNotifierProvider);

    final appendedFolderName = 'Downloaded ${widget.folderName}';

    return FutureBuilder<List<MusicModel>>(
      future: _musicFilesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No downloaded music found'));
        } else {
          final musicFiles = snapshot.data!;
          final recentPlaylistModel = CustomPlaylistModel(
            id: 'downloaded${widget.folderName}',
            title: widget.folderName,
            count: musicFiles.length,
            playlist: musicFiles,
            playListType: musicFiles.first.audioType,
          );
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Find in ${widget.folderName}',
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text('${musicFiles.length} track(s)'),
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
                                  .containsKey(appendedFolderName) &&
                              musicFiles.isNotEmpty) {
                            playlistModels.initializePlaylist(
                              widget.folderName,
                              appendedFolderName,
                              musicFiles,
                            );
                          }
                          playlistModels.setCurrentPlaylist(appendedFolderName);
                          playlistModels.playCurrentPlaylist();

                          recentPlaylistModel.playListType == 'Music'
                              ? ref
                                  .read(allMusicPlaylistsNotifierProvider
                                      .notifier)
                                  .addToPlaylists(recentPlaylistModel)
                              : ref
                                  .read(allDhammaPlaylistsNotifierProvider
                                      .notifier)
                                  .addToPlaylists(recentPlaylistModel);
                        },
                        icon: Icon(
                          playlistModels.playlists[appendedFolderName]
                                      ?.isPlaying ==
                                  true
                              ? CupertinoIcons.pause_circle_fill
                              : CupertinoIcons.play_circle_fill,
                        ),
                        iconSize: 60,
                        color: playlistModels
                                    .playlists[appendedFolderName]?.isPlaying ==
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
                child: SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: musicFiles.length,
                    itemBuilder: (context, index) {
                      final track = musicFiles[index];
                      debugPrint('Track: ${track.musicUrl}');
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            // musicNotifier.updateMusic(track);
                            // homeNotifier.updatePlayStatusToFirebase(
                            //   track: track,
                            // );
                          },
                          /* child: InactiveTrackWidget(
                            track: track,
                            isNetworkImage: false,
                          ), */
                          child: track.id ==
                                  playlistModels.playlists[appendedFolderName]
                                      ?.currentTrack?.id
                              ? ActiveAnimatedTrackWidget(
                                  track: track,
                                  // durationInMilliseconds: currentPlaylist!
                                  //     .audioPlayer.duration!.inMilliseconds,
                                  durationInMilliseconds: 250,
                                )
                              : InactiveTrackWidget(
                                  track: track,
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
