import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/constants/text_strings.dart';
import 'package:mingalar_music_app/core/models/custom_playlist_compilation_model.dart';
import 'package:mingalar_music_app/core/models/custom_playlist_model.dart';
import 'package:mingalar_music_app/core/providers/all_dhamma_playlists_notifier.dart';
import 'package:mingalar_music_app/core/providers/favorite_bhikkhu_notifier.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/widgets/loader.dart';
import 'package:mingalar_music_app/core/widgets/music_async_playlist_widget.dart';
import 'package:mingalar_music_app/core/widgets/music_async_usergen_playlist_widget.dart';
import 'package:mingalar_music_app/core/widgets/music_list_playlist_widget.dart';
import 'package:mingalar_music_app/features/dashboardDhamma/view/widgets/bhikkhu_detail_widget.dart';
import 'package:mingalar_music_app/features/dashboardMusic/view/widgets/chart_icon_widget.dart';
import 'package:mingalar_music_app/features/dashboardMusic/view/widgets/playlist_compilation_icon_widget.dart';
import 'package:mingalar_music_app/features/dhamma/models/bhikkhu_model.dart';
import 'package:mingalar_music_app/features/dhamma/viewmodel/dhamma_view_model.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';
import 'package:mingalar_music_app/features/home/viewmodel/home_view_model.dart';

class DashboardDhammaScreen extends ConsumerStatefulWidget {
  const DashboardDhammaScreen({super.key});

  @override
  ConsumerState<DashboardDhammaScreen> createState() =>
      _DashboardDhammaScreenState();
}

class _DashboardDhammaScreenState extends ConsumerState<DashboardDhammaScreen> {
  @override
  Widget build(BuildContext context) {
    final recentPlaylists = ref.watch(allDhammaPlaylistsNotifierProvider);
    final latestDhammaThisMonth = ref.watch(getAllTracksThisMonthProvider);
    final mingalarCompilations =
        ref.watch(getTenMingalarDhammaPlaylistsProvider);
    final fanPlaylists = ref.watch(getTenUserDhammaPlaylistsProvider);
    final Map<String, BhikkhuModel> favoriteBhikkhus =
        ref.watch(favoriteBhikkhuNotifierProvider);

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              recentPlaylists.isNotEmpty
                  ? _buildRecentPlaylists(recentPlaylists)
                  : const SizedBox(),
              _buildCharts(context, latestDhammaThisMonth),
              _buildBestOfFavBhikkhus(context, favoriteBhikkhus),
              _buildMingalarCompilations(context, mingalarCompilations),
              _buildFanPlaylists(context, fanPlaylists),
              _buildBhikkhus(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }

  Column _buildBestOfFavBhikkhus(
      BuildContext context, Map<String, BhikkhuModel> favoriteBhikkhus) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            tBestOfBhikkhus,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: favoriteBhikkhus.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final bhikkhu =
                  favoriteBhikkhus[favoriteBhikkhus.keys.elementAt(index)];
              final mostPlayedTracks = ref
                  .watch(fetchTopTenPlayedTracksByBhikkhuProvider(bhikkhu!.id));
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return MusicAsyncPlaylistWidget(
                          title: "Greatest of ဆရာတော် ${bhikkhu.nameMM}",
                          playlist: mostPlayedTracks,
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
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                  ),
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                      color: AppPallete.greyColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image(
                            width: 110,
                            // height: 100,
                            image: NetworkImage(
                              bhikkhu.profileImageUrl,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          bhikkhu.nameMM,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          bhikkhu.alias,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildMingalarCompilations(BuildContext context,
      AsyncValue<List<CustomPlaylistCompilationModel>> mingalarCompilations) {
    return mingalarCompilations.when(
      data: (compilationToSet) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                tMingalarCompilations,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SizedBox(
                height: 150,
                width: double.infinity,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: compilationToSet.length,
                  itemBuilder: (context, index) {
                    final playlist = compilationToSet[index];
                    final asyncTracks = ref.watch(
                      loadCustomPlaylistTracksProvider(
                        'mingalarDhammaPlaylists',
                        playlist.id,
                      ),
                    );
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return MusicAsyncUsergenPlaylistWidget(
                                playlistData: playlist,
                                asyncTracks: asyncTracks,
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

                              final offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: PlaylistCompilationIconWidget(
                        title: playlist.title,
                        asyncTracks: asyncTracks,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
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

  Widget _buildFanPlaylists(BuildContext context,
      AsyncValue<List<CustomPlaylistCompilationModel>> fanPlaylists) {
    return fanPlaylists.when(
      data: (playlistToSet) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                tFollowerPlaylists,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SizedBox(
                height: 150,
                width: double.infinity,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: playlistToSet.length,
                  itemBuilder: (context, index) {
                    final playlist = playlistToSet[index];
                    final asyncTracks = ref.watch(
                      loadCustomPlaylistTracksProvider(
                        'fanDhammaPlaylists',
                        playlist.id,
                      ),
                    );
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return MusicAsyncUsergenPlaylistWidget(
                                playlistData: playlist,
                                asyncTracks: asyncTracks,
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

                              final offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: PlaylistCompilationIconWidget(
                        title: playlist.title,
                        asyncTracks: asyncTracks,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
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

  Column _buildBhikkhus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tBhikkhus,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                tViewAll,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppPallete.greyColor,
                ),
              ),
            ],
          ),
        ),
        ref.watch(getTenBhikkhusProvider).when(
              data: (bhikkhus) {
                return SizedBox(
                  height: 300,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final bhikkhu = bhikkhus[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return BhikkhuDetailWidget(
                                        bhikkhuId: bhikkhu.id,
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
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      bhikkhu.profileImageUrl,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              bhikkhu.nameMM,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              bhikkhu.alias,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            bhikkhu.totalFollowers > 1000
                                ? Text(
                                    '${bhikkhu.totalFollowers % 1000}k followers',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppPallete.greyColor,
                                    ),
                                  )
                                : Text(
                                    '${bhikkhu.totalFollowers} followers',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppPallete.greyColor,
                                    ),
                                  ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox.shrink(),
                    itemCount: bhikkhus.length,
                  ),
                );
              },
              error: (error, st) {
                return Center(
                  child: Text(error.toString()),
                );
              },
              loading: () => const Loader(),
            )
      ],
    );
  }

  Column _buildCharts(BuildContext context,
      AsyncValue<List<MusicModel>> latestDhammaThisMonth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            tCharts,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: SizedBox(
              height: 130,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return MusicAsyncPlaylistWidget(
                              title: 'ယခုလ နောက်ဆုံးရ တရားတော်များ',
                              playlist: latestDhammaThisMonth,
                            );
                          },
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            final tween = Tween(
                                    begin: const Offset(1, 0), end: Offset.zero)
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
                    child: const ChartIconWidget(
                      colors: [
                        AppPallete.gradient4,
                        AppPallete.gradient5,
                      ],
                      title: 'ယခုလ နောက်ဆုံးရ',
                      subTitle: 'တရားတော်များ',
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  const ChartIconWidget(
                    colors: [
                      Color(0xff009245),
                      Color(0xfffcee21),
                    ],
                    title: 'ပူဇော်မှု အများဆုံး',
                    subTitle: 'တရားတော်များ',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Padding _buildRecentPlaylists(
      Map<String, CustomPlaylistModel> recentPlaylists) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        height: 60,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final playlist =
                recentPlaylists[recentPlaylists.keys.elementAt(index)];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return MusicListPlaylistWidget(
                        title: playlist.title,
                        playlist: playlist.playlist.toList(),
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
                        width: 50,
                        height: MediaQuery.of(context).size.height,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppPallete.gradient4,
                              AppPallete.gradient5,
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                          shape: BoxShape.rectangle,
                        ),
                        child: const Icon(
                          CupertinoIcons.music_note_list,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          playlist!.title,
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
          itemCount: recentPlaylists.length,
        ),
      ),
    );
  }
}
