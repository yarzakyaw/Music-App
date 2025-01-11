import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/models/custom_playlist_model.dart';
import 'package:mingalar_music_app/core/providers/favorite_music_notifier.dart';
import 'package:mingalar_music_app/core/widgets/create_upload_icon_text_button_widget.dart';
import 'package:mingalar_music_app/core/widgets/custom_playlist_icon_widget.dart';
import 'package:mingalar_music_app/core/widgets/music_list_playlist_widget.dart';
import 'package:mingalar_music_app/core/widgets/playlist_icon_widget.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';
import 'package:mingalar_music_app/features/home/view/screens/music_upload_screen.dart';
import 'package:mingalar_music_app/features/home/viewmodel/home_view_model.dart';
import 'package:mingalar_music_app/features/libraryDhammaPlaylist/view/widgets/create_dhamma_playlist_widget.dart';
import 'package:mingalar_music_app/features/libraryMusicPlaylist/view/widgets/create_music_playlist_widget.dart';
import 'package:mingalar_music_app/core/widgets/music_list_usergen_playlist_widget.dart';

class LibraryMusicPlaylistScreen extends ConsumerStatefulWidget {
  const LibraryMusicPlaylistScreen({super.key});

  @override
  ConsumerState<LibraryMusicPlaylistScreen> createState() =>
      _LibraryMusicPlaylistScreenState();
}

class _LibraryMusicPlaylistScreenState
    extends ConsumerState<LibraryMusicPlaylistScreen> {
  @override
  Widget build(BuildContext context) {
    final customPlaylists =
        ref.watch(homeViewModelProvider.notifier).getUserGeneratedPlaylists();

    final Map<String, MusicModel> favorites =
        ref.watch(favoriteMusicNotifierProvider);
    final Map<String, MusicModel> musicFavorites = {};

    for (int i = 0; i < favorites.length; i++) {
      final track = favorites[favorites.keys.elementAt(i)];
      if (track!.audioType == "Music") musicFavorites[track.id] = track;
    }

    final recentPlaylistModel = CustomPlaylistModel(
      id: 'likedSongs',
      title: 'Liked Songs',
      count: musicFavorites.values.toList().length,
      playlist: musicFavorites.values.toList(),
      playListType: 'Music',
    );

    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return MusicListPlaylistWidget(
                        title: 'Liked Songs',
                        playlist: musicFavorites.values.toList(),
                        customRecentPlaylist: recentPlaylistModel,
                      );
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      final tween =
                          Tween(begin: const Offset(1, 0), end: Offset.zero)
                              .chain(
                        CurveTween(
                          curve: Curves.easeIn,
                        ),
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
              child: PlaylistIconWidget(
                count: musicFavorites.length,
                title: 'Liked Songs',
              ),
            ),
            customPlaylists.isNotEmpty
                ? Flexible(
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: customPlaylists.length,
                      itemBuilder: (context, index) {
                        final customPlaylist = customPlaylists[index];

                        final customRecentPlaylistModel = CustomPlaylistModel(
                          id: customPlaylist.id,
                          title: customPlaylist.title,
                          count: customPlaylist.tracks.length,
                          playlist: customPlaylist.tracks,
                          playListType: 'Music',
                        );

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return MusicListUsergenPlaylistWidget(
                                    playlist: customPlaylist,
                                    customRecentPlaylist:
                                        customRecentPlaylistModel,
                                  );
                                },
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  final tween = Tween(
                                          begin: const Offset(1, 0),
                                          end: Offset.zero)
                                      .chain(
                                    CurveTween(
                                      curve: Curves.easeIn,
                                    ),
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
                          child: CustomPlaylistIconWidget(
                            title: customPlaylist.title,
                            description: customPlaylist.description,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                    ),
                  )
                : SizedBox(),
            const SizedBox(height: 10),
            CreateUploadIconTextButtonWidget(
              onTap: () {
                createModalBottomSheet(context);
              },
              title: 'Create Custom Playlist',
            ),
            const SizedBox(height: 10),
            CreateUploadIconTextButtonWidget(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const MusicUploadScreen();
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      final tween =
                          Tween(begin: const Offset(1, 0), end: Offset.zero)
                              .chain(
                        CurveTween(
                          curve: Curves.easeIn,
                        ),
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
              title: 'Upload New Track',
            ),
          ],
        ),
      ],
    );
  }

  Future<dynamic> createModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.25,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.music_note_rounded),
              title: Text('Create Music Playlist'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return CreateMusicPlaylistWidget();
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      final tween =
                          Tween(begin: const Offset(0, 1), end: Offset.zero)
                              .chain(
                        CurveTween(
                          curve: Curves.easeIn,
                        ),
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
            ),
            ListTile(
              leading: Icon(Icons.music_note_rounded),
              title: Text('Create Dhamma Playlist'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return CreateDhammaPlaylistWidget();
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      final tween =
                          Tween(begin: const Offset(0, 1), end: Offset.zero)
                              .chain(
                        CurveTween(
                          curve: Curves.easeIn,
                        ),
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
            ),
          ],
        ),
      ),
    );
  }
}

/* import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/models/custom_playlist_model.dart';
import 'package:mingalar_music_app/core/providers/favorite_music_notifier.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/widgets/create_upload_icon_text_button_widget.dart';
import 'package:mingalar_music_app/core/widgets/music_list_playlist_widget.dart';
import 'package:mingalar_music_app/core/widgets/playlist_icon_widget.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';

class LibraryMusicPlaylistScreen extends ConsumerStatefulWidget {
  const LibraryMusicPlaylistScreen({super.key});

  @override
  ConsumerState<LibraryMusicPlaylistScreen> createState() =>
      _LibraryMusicPlaylistScreenState();
}

class _LibraryMusicPlaylistScreenState
    extends ConsumerState<LibraryMusicPlaylistScreen> {
  bool _isVisible = false;
  String selectedWidget = '';
  String selectedWidgetTitle = '';
  Map<String, Widget> libraryMusicPlaylistWidgets = {};

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final Map<String, MusicModel> favorites =
        ref.watch(favoriteMusicNotifierProvider);
    final Map<String, MusicModel> musicFavorites = {};

    for (int i = 0; i < favorites.length; i++) {
      final track = favorites[favorites.keys.elementAt(i)];
      if (track!.audioType == "Music") musicFavorites[track.id] = track;
    }

    final recentPlaylistModel = CustomPlaylistModel(
      id: 'likedSongs',
      title: 'Liked Songs',
      count: musicFavorites.values.toList().length,
      playlist: musicFavorites.values.toList(),
      playListType: 'Music',
    );

    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  libraryMusicPlaylistWidgets['Liked Songs'] =
                      MusicListPlaylistWidget(
                    title: 'Liked Songs',
                    playlist: musicFavorites.values.toList(),
                    customRecentPlaylist: recentPlaylistModel,
                  );
                  selectedWidget = 'Liked Songs';
                  selectedWidgetTitle = 'Liked Songs';
                  _isVisible = !_isVisible;
                });
              },
              child: PlaylistIconWidget(
                count: musicFavorites.length,
                title: 'Liked Songs',
              ),
            ),
            //ListView.separated(itemBuilder: itemBuilder, separatorBuilder: separatorBuilder, itemCount: itemCount),
            const SizedBox(height: 10),
            CreateUploadIconTextButtonWidget(
              onTap: () {},
              title: 'Create Custom Playlist',
            ),
            const SizedBox(height: 10),
            CreateUploadIconTextButtonWidget(
              onTap: () {
                Navigator.pushNamed(context, 'MusicUploadScreen');
              },
              title: 'Upload New Track',
            ),
          ],
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          right: _isVisible ? 0 : -screenWidth,
          top: 0,
          child: Container(
            width: screenWidth,
            height: screenHeight,
            color: AppPallete.backgroundColor,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isVisible = !_isVisible;
                        });
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Text(
                      selectedWidgetTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.sort),
                    ),
                  ],
                ),
                libraryMusicPlaylistWidgets[selectedWidget] ?? const SizedBox(),
              ],
            ),
          ),
        ),
      ],
    );
  }
} */
