import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/constants/text_strings.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/features/dhamma/viewmodel/dhamma_view_model.dart';

class RecentDhammaTrackWidget extends ConsumerWidget {
  const RecentDhammaTrackWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentlyPlayedDhammaTrack = ref
        .watch(dhammaViewModelProvider.notifier)
        .getRecentlyPlayedDhammaTracks();
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tRecentTracklist,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              Text(
                tSeeMore,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Color(0xffC6C6C6),
                ),
              ),
            ],
          ),
        ),
        //const SizedBox(height: 10),
        SizedBox(
          height: 60,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final track = recentlyPlayedDhammaTrack[index];
              return GestureDetector(
                onTap: () {
                  // ref
                  //     .read(currentMusicNotifierProvider.notifier)
                  //     .updateMusic(track);
                  // ref
                  //     .read(homeViewModelProvider.notifier)
                  //     .updatePlayStatusToFirebase(
                  //       track: track,
                  //     );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 12),
                  child: Container(
                    width: 180,
                    decoration: BoxDecoration(
                      color: AppPallete.greyColor,
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
                                track.thumbnailUrl,
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
                            track.musicName,
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
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(),
            itemCount: recentlyPlayedDhammaTrack.length,
          ),
        ),
      ],
    );
  }
}
