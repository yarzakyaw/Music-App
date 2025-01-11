import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mingalar_music_app/core/constants/image_strings.dart';
import 'package:mingalar_music_app/core/models/custom_playlist_model.dart';
import 'package:mingalar_music_app/core/models/share_option_model.dart';
import 'package:mingalar_music_app/core/models/user_defined_playlist_model.dart';
import 'package:mingalar_music_app/core/providers/all_dhamma_playlists_notifier.dart';
import 'package:mingalar_music_app/core/providers/all_music_playlists_notifier.dart';
import 'package:mingalar_music_app/core/providers/current_playlist_notifier.dart';
import 'package:mingalar_music_app/core/providers/current_user_notifier.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/widgets/active_animated_track_widget.dart';
import 'package:mingalar_music_app/core/widgets/inactive_track_widget.dart';
import 'package:mingalar_music_app/features/download/view/screens/download_screen.dart';
import 'package:mingalar_music_app/features/home/viewmodel/home_view_model.dart';
import 'package:mingalar_music_app/features/libraryDhammaPlaylist/repositories/user_generated_dhamma_playlists_repository.dart';
import 'package:mingalar_music_app/features/libraryDhammaPlaylist/view/widgets/dhamma_selection_screen_widget.dart';
import 'package:mingalar_music_app/features/libraryMusicPlaylist/repositories/user_generated_playlists_repository.dart';
import 'package:mingalar_music_app/features/libraryMusicPlaylist/view/widgets/music_selection_screen_widget.dart';

class MusicListUsergenPlaylistWidget extends ConsumerStatefulWidget {
  final UserDefinedPlaylistModel playlist;
  final CustomPlaylistModel? customRecentPlaylist;
  const MusicListUsergenPlaylistWidget({
    super.key,
    required this.playlist,
    this.customRecentPlaylist,
  });

  @override
  ConsumerState<MusicListUsergenPlaylistWidget> createState() =>
      _MusicListUsergenPlaylistWidgetState();
}

class _MusicListUsergenPlaylistWidgetState
    extends ConsumerState<MusicListUsergenPlaylistWidget> {
  late ScrollController _scrollController;
  bool _showTitle = false;

  void toggleShuffle() {
    setState(() {
      ref.watch(currentPlaylistNotifierProvider.notifier).toggleShuffle();
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset > 200 && !_showTitle) {
        setState(() {
          _showTitle = true;
        });
      } else if (_scrollController.offset <= 200 && _showTitle) {
        setState(() {
          _showTitle = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final playlistModels = ref.watch(currentPlaylistNotifierProvider.notifier);
    final currentPlaylist =
        playlistModels.playlists[playlistModels.activePlaylistId];
    final shuffleEnabled = currentPlaylist == null
        ? false
        : currentPlaylist.audioPlayer.shuffleModeEnabled;
    ref.watch(currentPlaylistNotifierProvider);
    ref.watch(allMusicPlaylistsNotifierProvider);
    ref.watch(allDhammaPlaylistsNotifierProvider);

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          expandedHeight: 300.0,
          pinned: true,
          title: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _showTitle ? 1.0 : 0.0,
            child: Container(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                widget.playlist.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          centerTitle: true,
          flexibleSpace: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Opacity(
                      opacity: _showTitle ? 0.0 : 1.0,
                      child: Icon(
                        Icons.music_note,
                        size: 100,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          widget.playlist.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          backgroundColor: isDark
              ? AppPallete.backgroundColor
              : AppPallete.lightBackgroundColor,
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      widget.playlist.creatorName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppPallete.greyColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: buildHashtags(widget.playlist.hashtags),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return DownloadScreen(
                                        playlist: widget.playlist.tracks,
                                        playlistTitle: widget.playlist.title,
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

                                      final offsetAnimation =
                                          animation.drive(tween);

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
                            IconButton(
                              onPressed: () {
                                shareModalBottomSheet(context);
                              },
                              icon: Icon(
                                Icons.share,
                                size: 35,
                                color: AppPallete.greyColor,
                              ),
                            ),
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
                                        .containsKey(widget.playlist.title) &&
                                    widget.playlist.tracks.isNotEmpty) {
                                  playlistModels.initializePlaylist(
                                    widget.playlist.title,
                                    widget.playlist.title,
                                    widget.playlist.tracks,
                                  );
                                }
                                playlistModels
                                    .setCurrentPlaylist(widget.playlist.title);
                                playlistModels.playCurrentPlaylist();

                                if (widget.customRecentPlaylist != null) {
                                  widget.customRecentPlaylist!.playListType ==
                                          'Music'
                                      ? ref
                                          .read(
                                              allMusicPlaylistsNotifierProvider
                                                  .notifier)
                                          .addToPlaylists(
                                              widget.customRecentPlaylist!)
                                      : ref
                                          .read(
                                              allDhammaPlaylistsNotifierProvider
                                                  .notifier)
                                          .addToPlaylists(
                                              widget.customRecentPlaylist!);
                                }
                              },
                              icon: Icon(
                                playlistModels.playlists[widget.playlist.title]
                                            ?.isPlaying ==
                                        true
                                    ? CupertinoIcons.pause_circle_fill
                                    : CupertinoIcons.play_circle_fill,
                              ),
                              iconSize: 60,
                              color: playlistModels
                                          .playlists[widget.playlist.title]
                                          ?.isPlaying ==
                                      true
                                  ? AppPallete.greenColor
                                  : AppPallete.greyColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Divider(indent: 30, endIndent: 30, thickness: 3),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return widget.playlist.tracks.first.audioType ==
                                  'Music'
                              ? MusicSelectionScreenWidget(
                                  playlist: widget.playlist,
                                )
                              : DhammaSelectionScreenWidget(
                                  playlist: widget.playlist,
                                );
                        },
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          final tween =
                              Tween(begin: const Offset(0, 1), end: Offset.zero)
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
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('Add music to this playlist'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 0),
                child: widget.playlist.tracks.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.playlist.tracks.length,
                        itemBuilder: (context, index) {
                          final track = widget.playlist.tracks[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: GestureDetector(
                              onTap: () {},
                              child: track.id ==
                                      playlistModels
                                          .playlists[widget.playlist.title]
                                          ?.currentTrack
                                          ?.id
                                  ? ActiveAnimatedTrackWidget(
                                      track: track,
                                      durationInMilliseconds: 250,
                                    )
                                  : InactiveTrackWidget(track: track),
                            ),
                          );
                        },
                      )
                    : SizedBox(),
              ),
              const SizedBox(height: 380)
            ],
          ),
        ),
      ],
    );
  }

  Future<dynamic> shareModalBottomSheet(BuildContext context) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    List<ShareOptionModel> sharingOptions = [
      ShareOptionModel(
        title: 'Playlists',
        icon: Icons.file_upload_outlined,
        onPressed: () async {
          try {
            DocumentSnapshot userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser!.userDetails!.uid)
                .get();
            final bool isAdmin =
                (userDoc.data() as Map<String, dynamic>)['accountType'] ==
                    'admin';
            ref
                .read(homeViewModelProvider.notifier)
                .uploadUserGenPlaylistToFirebase(
                  playlist: widget.playlist,
                  creatorName:
                      isAdmin ? 'Mingalar' : widget.playlist.creatorName,
                );

            widget.playlist.tracks.first.audioType == 'Music'
                ? ref
                    .read(userGeneratedPlaylistsRepositoryProvider)
                    .editPlaylistDetails(
                      widget.playlist.id,
                      newIsShared: true,
                    )
                : ref
                    .read(userGeneratedDhammaPlaylistsRepositoryProvider)
                    .editPlaylistDetails(
                      widget.playlist.id,
                      newIsShared: true,
                    );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isAdmin
                    ? "Successfully shared to the Mingalar Compilations!"
                    : "Successfully shared to the Followers'/Fan's Playlists!"),
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          }
        },
      ),
      ShareOptionModel(
        title: 'Copy Link',
        icon: Icons.link,
        onPressed: () {},
      ),
      ShareOptionModel(
        title: 'X',
        icon: Icons.share,
        onPressed: () {},
      ),
      ShareOptionModel(
        title: 'TikTok',
        icon: Icons.music_note,
        onPressed: () {},
      ),
      ShareOptionModel(
        title: 'Messages',
        icon: Icons.message,
        onPressed: () {},
      ),
      ShareOptionModel(
        title: 'Messenger',
        icon: Icons.facebook,
        onPressed: () {},
      ),
      ShareOptionModel(
        title: 'Snapchat',
        icon: Icons.snapchat,
        onPressed: () {},
      ),
      ShareOptionModel(
        title: 'More',
        icon: Icons.more_horiz,
        onPressed: () {},
      ),
    ];
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.3,
        padding: const EdgeInsets.all(8),
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: sharingOptions.length,
          itemBuilder: (context, index) {
            final option = sharingOptions[index];
            return GestureDetector(
              onTap: () {
                option.onPressed();
                Navigator.pop(context);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(option.icon, size: 30),
                  SizedBox(height: 4),
                  Text(option.title, textAlign: TextAlign.center),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget buildHashtags(List<String> hashtags) {
  return Wrap(
    spacing: 8.0,
    children: hashtags.map((tag) {
      return GestureDetector(
        onTap: () {
          // Trigger search or navigation to hashtag results
        },
        child: Chip(
          label: Text(tag),
          backgroundColor: Colors.blueAccent,
        ),
      );
    }).toList(),
  );
}
