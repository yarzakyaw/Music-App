import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/models/custom_playlist_model.dart';
import 'package:mingalar_music_app/core/providers/favorite_music_notifier.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/widgets/create_upload_icon_text_button_widget.dart';
import 'package:mingalar_music_app/core/widgets/custom_playlist_icon_widget.dart';
import 'package:mingalar_music_app/core/widgets/music_list_playlist_widget.dart';
import 'package:mingalar_music_app/core/widgets/music_list_usergen_playlist_widget.dart';
import 'package:mingalar_music_app/core/widgets/playlist_icon_widget.dart';
import 'package:mingalar_music_app/features/dhamma/view/screens/dhamma_upload_screen.dart';
import 'package:mingalar_music_app/features/dhamma/viewmodel/dhamma_view_model.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';
import 'package:mingalar_music_app/features/libraryDhammaPlaylist/view/widgets/create_dhamma_playlist_widget.dart';
import 'package:mingalar_music_app/features/libraryMusicPlaylist/view/widgets/create_music_playlist_widget.dart';

class LibraryDhammaPlaylistScreen extends ConsumerStatefulWidget {
  const LibraryDhammaPlaylistScreen({super.key});

  @override
  ConsumerState<LibraryDhammaPlaylistScreen> createState() =>
      _LibraryDhammaPlaylistScreenState();
}

class _LibraryDhammaPlaylistScreenState
    extends ConsumerState<LibraryDhammaPlaylistScreen> {
  @override
  Widget build(BuildContext context) {
    final customPlaylists = ref
        .watch(dhammaViewModelProvider.notifier)
        .getUserGeneratedDhammaPlaylists();

    final Map<String, MusicModel> favorites =
        ref.watch(favoriteMusicNotifierProvider);
    final Map<String, MusicModel> dhammaFavorites = {};

    for (int i = 0; i < favorites.length; i++) {
      final track = favorites[favorites.keys.elementAt(i)];
      if (track!.audioType == "Dhamma") dhammaFavorites[track.id] = track;
    }

    final recentPlaylistModel = CustomPlaylistModel(
      id: 'likedDhammaTracks',
      title: 'Liked Dhama Tracks',
      count: dhammaFavorites.values.toList().length,
      playlist: dhammaFavorites.values.toList(),
      playListType: 'Dhamma',
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
                        title: 'Liked Dhamma Tracks',
                        playlist: dhammaFavorites.values.toList(),
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
                  count: dhammaFavorites.length,
                  title: 'Liked Dhamma Tracks',
                  colors: const [
                    AppPallete.gradient4,
                    AppPallete.gradient5,
                  ]),
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
                          playListType: 'Dhamma',
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
                      return const DhammaUploadScreen();
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
              title: 'Upload New Dhamma Track',
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
        height: MediaQuery.of(context).size.height * 0.18,
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
