import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/models/custom_playlist_model.dart';
import 'package:mingalar_music_app/core/providers/favorite_music_notifier.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/widgets/create_upload_icon_text_button_widget.dart';
import 'package:mingalar_music_app/core/widgets/music_list_playlist_widget.dart';
import 'package:mingalar_music_app/core/widgets/playlist_icon_widget.dart';
import 'package:mingalar_music_app/features/dhamma/view/screens/dhamma_upload_screen.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';

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
            //ListView.separated(itemBuilder: itemBuilder, separatorBuilder: separatorBuilder, itemCount: itemCount),
            const SizedBox(height: 10),
            CreateUploadIconTextButtonWidget(
              onTap: () {},
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
}
