import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mingalar_music_app/core/constants/image_strings.dart';
import 'package:mingalar_music_app/core/providers/current_music_notifier.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/widgets/custom_app_bar.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';

class FavoritePlaylistScreen extends ConsumerStatefulWidget {
  final List<MusicModel> playlist;
  final String title;

  const FavoritePlaylistScreen({
    super.key,
    required this.title,
    required this.playlist,
  });

  @override
  ConsumerState<FavoritePlaylistScreen> createState() =>
      _FavoritePlaylistScreenState();
}

class _FavoritePlaylistScreenState
    extends ConsumerState<FavoritePlaylistScreen> {
  bool shuffle = true;

  void toggleShuffle() {
    setState(() {
      shuffle = !shuffle;
      ref.read(currentMusicNotifierProvider.notifier).toggleShuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final musicNotifier = ref.watch(currentMusicNotifierProvider.notifier);
    // final homeNotifier = ref.read(homeViewModelProvider.notifier);

    if (musicNotifier.playlist!.children.isEmpty) {
      musicNotifier.setPlaylist(widget.playlist);
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(widget.title),
        action: IconButton(
          icon: const Icon(Icons.sort),
          onPressed: () {
            // Sort action
          },
        ),
      ),
      body: Stack(
        children: [
          Column(
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
                        onPressed: () {},
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
                                    AppPallete.greenColor, BlendMode.srcIn)
                                : const ColorFilter.mode(
                                    AppPallete.greyColor, BlendMode.srcIn),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          musicNotifier.playAll();
                          setState(() {});
                        },
                        icon: Icon(
                          musicNotifier.isPlaying
                              ? CupertinoIcons.pause_circle_fill
                              : CupertinoIcons.play_circle_fill,
                        ),
                        iconSize: 60,
                        color: musicNotifier.isPlaying
                            ? AppPallete.greenColor
                            : AppPallete.greyColor,
                      ),
                    ],
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Divider(
                  indent: 30,
                  endIndent: 30,
                  thickness: 3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppPallete.whiteColor)),
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
              Expanded(
                child: ListView.builder(
                  itemCount: widget.playlist.length,
                  itemBuilder: (context, index) {
                    final track = widget.playlist[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          // musicNotifier.updateMusic(track);
                          // homeNotifier.updatePlayStatusToFirebase(
                          //   track: track,
                          // );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            title: Text(track.musicName),
                            subtitle: Text(track.artist),
                            leading: Container(
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
                            trailing: IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {
                                // More options action
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// class MusicTile extends StatelessWidget {
//   final MusicModel track;

//   const MusicTile({super.key, required this.track});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black26,
//             spreadRadius: 2,
//             blurRadius: 8,
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Placeholder for song image
//               ClipRRect(
//                 borderRadius:
//                     const BorderRadius.vertical(top: Radius.circular(8)),
//                 child: Image.network(
//                   track.musicUrl, // Replace with actual image URL
//                   height: 100,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       track.musicName,
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     Text(track.artist),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           // Play button overlay
//           Positioned(
//             right: 8,
//             top: 8,
//             child: IconButton(
//               icon: const Icon(Icons.play_circle_fill,
//                   color: Colors.green, size: 40),
//               onPressed: () {
//                 // Play song action
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
