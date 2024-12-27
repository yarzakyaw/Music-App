import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/constants/text_strings.dart';
import 'package:mingalar_music_app/core/providers/current_music_notifier.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/utils.dart';
import 'package:mingalar_music_app/core/widgets/loader.dart';
import 'package:mingalar_music_app/features/dashboard/view/widgets/recent_dhamma_track_widget.dart';
import 'package:mingalar_music_app/features/dhamma/viewmodel/dhamma_view_model.dart';

class DhammaWidget extends ConsumerWidget {
  const DhammaWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTrack = ref.watch(currentMusicNotifierProvider);
    // final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return ref.watch(getAllDhammaTracksProvider).when(
          data: (track) {
            return SingleChildScrollView(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                decoration: currentTrack == null
                    ? null
                    : BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            hexToColor(currentTrack.hexCode),
                            AppPallete.transparentColor,
                          ],
                          stops: const [0.0, 0.3],
                        ),
                      ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const RecentDhammaTrackWidget(),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        tLatestToday,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 220,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final track_ = track[index];
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 12.0),
                            child: GestureDetector(
                              onTap: () {
                                // ref
                                //     .read(currentMusicNotifierProvider.notifier)
                                //     .updateMusic(track_);
                                // ref
                                //     .read(homeViewModelProvider.notifier)
                                //     .updatePlayStatusToFirebase(
                                //       track: track_,
                                //     );
                              },
                              child: SizedBox(
                                width: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                track_.thumbnailUrl),
                                          ),
                                        ),
                                        // child: Align(
                                        //   alignment: Alignment.bottomRight,
                                        //   child: Container(
                                        //     height: 40,
                                        //     width: 40,
                                        //     transform: Matrix4.translationValues(
                                        //         10, 10, 0),
                                        //     decoration: BoxDecoration(
                                        //         shape: BoxShape.circle,
                                        //         color: isDark
                                        //             ? AppPallete.greyColor
                                        //             : const Color(0xffE6E6E6)),
                                        //     child: IconButton(
                                        //       onPressed: () {
                                        //         ref
                                        //             .read(
                                        //                 currentMusicNotifierProvider
                                        //                     .notifier)
                                        //             .updateMusic(track_);
                                        //         ref
                                        //             .read(homeViewModelProvider
                                        //                 .notifier)
                                        //             .updatePlayStatusToFirebase(
                                        //               track: track_,
                                        //             );
                                        //       },
                                        //       icon: const Icon(
                                        //           Icons.play_arrow_rounded),
                                        //       color: isDark
                                        //           ? AppPallete.backgroundColor
                                        //           : const Color(0xff555555),
                                        //     ),
                                        //   ),
                                        // ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      track_.musicName,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      track_.artist,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(),
                        itemCount: track.length,
                      ),
                    ),
                    const SizedBox(height: 100)
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
          loading: () => const Loader(),
        );
  }
}
