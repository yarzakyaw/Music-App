import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mingalar_music_app/core/constants/image_strings.dart';
import 'package:mingalar_music_app/core/constants/text_strings.dart';
import 'package:mingalar_music_app/core/providers/current_playlist_notifier.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/utils.dart';
import 'package:mingalar_music_app/features/dashboardDhamma/view/screens/dashboard_dhamma_screen.dart';
import 'package:mingalar_music_app/features/dashboardMusic/view/screens/dashboard_music_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    final currentTrack = ref.watch(currentPlaylistNotifierProvider);
    _tabController = TabController(length: 5, vsync: this);
    return AnimatedContainer(
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
                stops: const [0.1, 0.6],
              ),
            ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _homeTopCard(),
          _tabs(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const DashboardMusicScreen(),
                const DashboardDhammaScreen(),
                Container(),
                Container(),
                Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _homeTopCard() {
    return Column(
      children: [
        // Align(
        //   alignment: Alignment.topCenter,
        //   child: SvgPicture.asset(iLogo),
        // ),
        const SizedBox(height: 35),
        SvgPicture.asset(iLogo),
        Center(
          child: SizedBox(
            height: 140,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppPallete.green,
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'New Album',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: AppPallete.whiteColor,
                          ),
                        ),
                        Text(
                          'Happier than Ever',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: AppPallete.whiteColor,
                          ),
                        ),
                        Text(
                          'Billie Eilish',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: AppPallete.whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 60),
                    child: Image.asset(iHomeArtist),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _tabs() {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return TabBar(
      tabAlignment: TabAlignment.start,
      controller: _tabController,
      isScrollable: true,
      labelColor: isDark ? AppPallete.whiteColor : AppPallete.backgroundColor,
      indicatorColor: AppPallete.green,
      padding: const EdgeInsets.symmetric(vertical: 15),
      tabs: const [
        Text(
          tMusic,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        Text(
          tDhamma,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        Text(
          'Artists',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        Text(
          'Podcasts',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        Text(
          'Others',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        )
      ],
    );
  }
}


/* import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mingalar_music_app/core/constants/image_strings.dart';
import 'package:mingalar_music_app/core/constants/text_strings.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/features/dashboardDhamma/view/screens/dashboard_dhamma_screen.dart';
import 'package:mingalar_music_app/features/dashboardMusic/view/screens/dashboard_music_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  Widget build(BuildContext context) {
    _tabController = TabController(length: 5, vsync: this);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _homeTopCard(),
        _tabs(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              Navigator(
                onGenerateRoute: (settings) {
                  return MaterialPageRoute(
                    builder: (context) => const DashboardMusicScreen(),
                  );
                },
              ),
              Navigator(
                onGenerateRoute: (settings) {
                  return MaterialPageRoute(
                    builder: (context) => const DashboardDhammaScreen(),
                  );
                },
              ),
              Container(),
              Container(),
              Container(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _homeTopCard() {
    return Column(
      children: [
        // Align(
        //   alignment: Alignment.topCenter,
        //   child: SvgPicture.asset(iLogo),
        // ),
        const SizedBox(height: 35),
        SvgPicture.asset(iLogo),
        Center(
          child: SizedBox(
            height: 140,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppPallete.green,
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'New Album',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: AppPallete.whiteColor,
                          ),
                        ),
                        Text(
                          'Happier than Ever',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: AppPallete.whiteColor,
                          ),
                        ),
                        Text(
                          'Billie Eilish',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: AppPallete.whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 60),
                    child: Image.asset(iHomeArtist),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _tabs() {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return TabBar(
      tabAlignment: TabAlignment.start,
      controller: _tabController,
      isScrollable: true,
      labelColor: isDark ? AppPallete.whiteColor : AppPallete.backgroundColor,
      indicatorColor: AppPallete.green,
      padding: const EdgeInsets.symmetric(vertical: 15),
      tabs: const [
        Text(
          tMusic,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        Text(
          tDhamma,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        Text(
          'Artists',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        Text(
          'Podcasts',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        Text(
          'Others',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        )
      ],
    );
  }
} */



