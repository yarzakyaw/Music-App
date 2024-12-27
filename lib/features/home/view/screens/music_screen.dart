import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/constants/text_strings.dart';
import 'package:mingalar_music_app/core/providers/current_music_notifier.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/utils.dart';
import 'package:mingalar_music_app/core/widgets/loader.dart';
import 'package:mingalar_music_app/features/home/viewmodel/home_view_model.dart';

class MusicScreen extends ConsumerWidget {
  const MusicScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMusic = ref.watch(currentMusicNotifierProvider);
    final recentlyPlayedMusic =
        ref.watch(homeViewModelProvider.notifier).getRecentlyPlayedMusic();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: currentMusic == null
          ? null
          : BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  hexToColor(currentMusic.hexCode),
                  AppPallete.transparentColor,
                ],
                stops: const [0.0, 0.3],
              ),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 36),
            child: SizedBox(
              height: 280,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: recentlyPlayedMusic.length,
                itemBuilder: (context, index) {
                  final music = recentlyPlayedMusic[index];
                  return GestureDetector(
                    onTap: () {
                      // ref
                      //     .read(currentMusicNotifierProvider.notifier)
                      //     .updateMusic(music);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppPallete.borderColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  music.thumbnailUrl,
                                ),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                bottomLeft: Radius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              music.musicName,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              tLatestToday,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ref.watch(getAllMusicProvider).when(
                data: (music) {
                  return SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: music.length,
                      itemBuilder: (context, index) {
                        final music_ = music[index];
                        return GestureDetector(
                          onTap: () {
                            // ref
                            //     .read(currentMusicNotifierProvider.notifier)
                            //     .updateMusic(music_);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        music_.thumbnailUrl,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    music_.musicName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    music_.artist,
                                    style: const TextStyle(
                                      color: AppPallete.subtitleText,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
                loading: () => const Loader(),
              ),
        ],
      ),
    );
  }
}
