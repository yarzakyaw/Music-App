import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/constants/text_strings.dart';
import 'package:mingalar_music_app/core/models/custom_playlist_model.dart';
import 'package:mingalar_music_app/core/providers/all_music_playlists_notifier.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/widgets/loader.dart';
import 'package:mingalar_music_app/core/widgets/music_async_playlist_widget.dart';
import 'package:mingalar_music_app/core/widgets/music_list_playlist_widget.dart';
import 'package:mingalar_music_app/features/dashboardMusic/view/widgets/artist_detail_widget.dart';
import 'package:mingalar_music_app/features/dashboardMusic/view/widgets/chart_icon_widget.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';
import 'package:mingalar_music_app/features/home/viewmodel/home_view_model.dart';

class DashboardMusicScreen extends ConsumerStatefulWidget {
  const DashboardMusicScreen({super.key});

  @override
  ConsumerState<DashboardMusicScreen> createState() =>
      _DashboardMusicScreenState();
}

class _DashboardMusicScreenState extends ConsumerState<DashboardMusicScreen> {
  @override
  Widget build(BuildContext context) {
    final recentPlaylists = ref.watch(allMusicPlaylistsNotifierProvider);
    final latestMusicThisWeek = ref.watch(getAllMusicProvider);

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              recentPlaylists.isNotEmpty
                  ? _buildRecentPlaylists(recentPlaylists)
                  : const SizedBox(),
              _buildCharts(context, latestMusicThisWeek),
              _buildArtists(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }

  Column _buildArtists() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tArtists,
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
        ref.watch(getTenArtistsProvider).when(
              data: (artists) {
                return SizedBox(
                  height: 200,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final artist = artists[index];
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
                                      return ArtistDetailWidget(
                                        artistId: artist.id,
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
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  artist.profileImageUrl,
                                ),
                                radius: 60,
                              ),
                            ),
                            Text(
                              artist.nameENG,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            artist.totalFollowers > 1000
                                ? Text(
                                    '${artist.totalFollowers % 1000}k followers',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppPallete.greyColor,
                                    ),
                                  )
                                : Text(
                                    '${artist.totalFollowers} followers',
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
                    itemCount: artists.length,
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

  Column _buildCharts(
      BuildContext context, AsyncValue<List<MusicModel>> latestMusicThisWeek) {
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
                              title: 'Latest Music This Week',
                              playlist: latestMusicThisWeek,
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
                        AppPallete.gradient1,
                        AppPallete.gradient2,
                      ],
                      title: 'Latest',
                      subTitle: 'This Week',
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  const ChartIconWidget(
                    colors: [
                      Color(0xff009245),
                      Color(0xfffcee21),
                    ],
                    title: 'Top 50',
                    subTitle: 'This Year',
                  ),
                  const SizedBox(width: 8.0),
                  const ChartIconWidget(
                    colors: [
                      Color(0xffD8B5FF),
                      Color(0xff1EAE98),
                    ],
                    title: 'Top 100',
                    subTitle: 'All Time',
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
                              AppPallete.gradient1,
                              AppPallete.gradient2,
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

/* import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/constants/text_strings.dart';
import 'package:mingalar_music_app/core/providers/all_music_playlists_notifier.dart';
import 'package:mingalar_music_app/core/providers/current_playlist_notifier.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/utils.dart';
import 'package:mingalar_music_app/core/widgets/loader.dart';
import 'package:mingalar_music_app/core/widgets/music_async_playlist_widget.dart';
import 'package:mingalar_music_app/core/widgets/music_list_playlist_widget.dart';
import 'package:mingalar_music_app/features/dashboardMusic/view/widgets/artist_detail_widget.dart';
import 'package:mingalar_music_app/features/dashboardMusic/view/widgets/chart_icon_widget.dart';
import 'package:mingalar_music_app/features/home/viewmodel/home_view_model.dart';

class DashboardMusicScreen extends ConsumerStatefulWidget {
  const DashboardMusicScreen({super.key});

  @override
  ConsumerState<DashboardMusicScreen> createState() =>
      _DashboardMusicScreenState();
}

class _DashboardMusicScreenState extends ConsumerState<DashboardMusicScreen> {
  bool _isVisible = false;
  String selectedWidget = '';
  Map<String, Widget> dashboardMusicWidgets = {};

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final recentPlaylists = ref.watch(allMusicPlaylistsNotifierProvider);
    final latestMusicThisWeek = ref.watch(getAllMusicThisWeekProvider);
    final currentTrack = ref.watch(currentPlaylistNotifierProvider);

    return Stack(
      children: [
        SingleChildScrollView(
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
                      stops: const [0.0, 0.6],
                    ),
                  ),
            child: Column(
              children: [
                recentPlaylists.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          height: 60,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final playlist = recentPlaylists[
                                  recentPlaylists.keys.elementAt(index)];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    dashboardMusicWidgets[playlist.title] =
                                        MusicListPlaylistWidget(
                                      title: playlist.title,
                                      playlist: playlist.playlist.toList(),
                                    );
                                    selectedWidget = playlist.title;
                                    _isVisible = !_isVisible;
                                  });
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 12),
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
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppPallete.gradient1,
                                                AppPallete.gradient2,
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
                            separatorBuilder: (context, index) =>
                                const SizedBox(),
                            itemCount: recentPlaylists.length,
                          ),
                        ),
                      )
                    : const SizedBox(),
                Column(
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
                                // onTap: _toggleVisible,
                                onTap: () {
                                  setState(() {
                                    dashboardMusicWidgets['Latest This Week'] =
                                        MusicAsyncPlaylistWidget(
                                      title: 'Latest This Week',
                                      playlist: latestMusicThisWeek,
                                    );
                                    selectedWidget = 'Latest This Week';
                                    _isVisible = !_isVisible;
                                  });
                                },
                                child: const ChartIconWidget(
                                  colors: [
                                    AppPallete.gradient1,
                                    AppPallete.gradient2,
                                  ],
                                  title: 'Latest',
                                  subTitle: 'This Week',
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              const ChartIconWidget(
                                colors: [
                                  Color(0xff009245),
                                  Color(0xfffcee21),
                                ],
                                title: 'Top 50',
                                subTitle: 'This Year',
                              ),
                              const SizedBox(width: 8.0),
                              const ChartIconWidget(
                                colors: [
                                  Color(0xffD8B5FF),
                                  Color(0xff1EAE98),
                                ],
                                title: 'Top 100',
                                subTitle: 'All Time',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // if(recentlyPlayedMusic.isNotEmpty) {
                //   PlaylistIconWidget(count: recentlyPlayedMusic.length, title: 'Recently Played',);
                // },
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tArtists,
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
                    ref.watch(getAllArtistsProvider).when(
                          data: (artists) {
                            return SizedBox(
                              height: 200,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final artist = artists[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ArtistDetailWidget(
                                                  artistId: artist.id,
                                                ),
                                              ),
                                            );
                                          },
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              artist.profileImageUrl,
                                            ),
                                            radius: 60,
                                          ),
                                        ),
                                        Text(
                                          artist.nameENG,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        artist.totalFollowers > 1000
                                            ? Text(
                                                '${artist.totalFollowers % 1000}k followers',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppPallete.greyColor,
                                                ),
                                              )
                                            : Text(
                                                '${artist.totalFollowers} followers',
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
                                itemCount: artists.length,
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
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tArtists,
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
                    ref.watch(getAllArtistsProvider).when(
                          data: (artists) {
                            return SizedBox(
                              height: 200,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final artist = artists[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Column(
                                        children: [
                                          Hero(
                                            tag: artist.id,
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                artist.profileImageUrl,
                                              ),
                                              radius: 60,
                                            ),
                                          ),
                                          Text(
                                            artist.nameENG,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          artist.totalFollowers > 1000
                                              ? Text(
                                                  '${artist.totalFollowers % 1000}k followers',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppPallete.greyColor,
                                                  ),
                                                )
                                              : Text(
                                                  '${artist.totalFollowers} followers',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppPallete.greyColor,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox.shrink(),
                                itemCount: artists.length,
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
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          right: _isVisible ? 0 : -screenWidth,
          top: 0,
          child: Container(
            width: screenWidth,
            height: screenHeight,
            color: isDark
                ? AppPallete.backgroundColor
                : AppPallete.lightBackgroundColor,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isVisible = !_isVisible;
                          selectedWidget = '';
                        });
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Text(
                      selectedWidget,
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
                dashboardMusicWidgets[selectedWidget] ?? const SizedBox(),
              ],
            ),
          ),
        ),
      ],
    );
  }
} */


/* import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/constants/text_strings.dart';
import 'package:mingalar_music_app/core/models/custom_playlist_model.dart';
import 'package:mingalar_music_app/core/providers/all_music_playlists_notifier.dart';
import 'package:mingalar_music_app/core/providers/current_playlist_notifier.dart';
import 'package:mingalar_music_app/core/providers/recent_music_playlists_notifier.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/utils.dart';
import 'package:mingalar_music_app/core/widgets/music_async_playlist_widget.dart';
import 'package:mingalar_music_app/core/widgets/music_list_playlist_widget.dart';
import 'package:mingalar_music_app/features/dashboardMusic/view/widgets/chart_icon_widget.dart';
import 'package:mingalar_music_app/features/dashboardMusic/view/widgets/temp_widget.dart';
import 'package:mingalar_music_app/features/home/viewmodel/home_view_model.dart';

class DashboardMusicScreen extends ConsumerStatefulWidget {
  const DashboardMusicScreen({super.key});

  @override
  ConsumerState<DashboardMusicScreen> createState() =>
      _DashboardMusicScreenState();
}

class _DashboardMusicScreenState extends ConsumerState<DashboardMusicScreen> {
  @override
  Widget build(BuildContext context) {
    final recentPlaylists = ref.watch(recentMusicPlaylistsNotifierProvider);
    final latestMusicThisWeek = ref.watch(getAllMusicThisWeekProvider);
    final currentTrack = ref.watch(currentPlaylistNotifierProvider);

    ref.listen(allMusicPlaylistsNotifierProvider, (previous, next) {
      if (next.isNotEmpty) {
        ref
            .read(recentMusicPlaylistsNotifierProvider.notifier)
            .setRecentPlaylists(next);
      }
    });

    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => SingleChildScrollView(
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
                        stops: const [0.0, 0.6],
                      ),
                    ),
              child: Column(
                children: [
                  recentPlaylists.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            height: 60,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final playlist = recentPlaylists[
                                    recentPlaylists.keys.elementAt(index)];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MusicListPlaylistWidget(
                                          title: playlist.title,
                                          playlist: playlist.playlist.toList(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                      right: 12,
                                    ),
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
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  AppPallete.gradient1,
                                                  AppPallete.gradient2,
                                                ],
                                                begin: Alignment.bottomLeft,
                                                end: Alignment.topRight,
                                              ),
                                              // border: Border.all(color: AppPallete.borderColor),
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
                              separatorBuilder: (context, index) =>
                                  const SizedBox(),
                              itemCount: recentPlaylists.length,
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Column(
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
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return MusicAsyncPlaylistWidget(
                                            title: 'Latest This Week',
                                            playlist: ref.watch(
                                                getAllMusicThisWeekProvider),
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
                                  child: const ChartIconWidget(
                                    colors: [
                                      AppPallete.gradient1,
                                      AppPallete.gradient2,
                                    ],
                                    title: 'Latest',
                                    subTitle: 'This Week',
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                const ChartIconWidget(
                                  colors: [
                                    Color(0xff009245),
                                    Color(0xfffcee21),
                                  ],
                                  title: 'Top 50',
                                  subTitle: 'This Year',
                                ),
                                const SizedBox(width: 8.0),
                                const ChartIconWidget(
                                  colors: [
                                    Color(0xffD8B5FF),
                                    Color(0xff1EAE98),
                                  ],
                                  title: 'Top 100',
                                  subTitle: 'All Time',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // if(recentlyPlayedMusic.isNotEmpty) {
                  //   PlaylistIconWidget(count: recentlyPlayedMusic.length, title: 'Recently Played',);
                  // },
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} */


