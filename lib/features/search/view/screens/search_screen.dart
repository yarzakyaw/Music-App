import 'package:flutter/material.dart';
import 'package:mingalar_music_app/core/constants/text_strings.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/features/searchDhamma/view/screens/search_dhamma_screen.dart';
import 'package:mingalar_music_app/features/searchMusic/view/screens/search_music_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    _tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      appBar: AppBar(
        title: const Text(tSearchHome),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _tabs(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                SearchMusicScreen(),
                SearchDhammaScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabs() {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return TabBar(
      tabAlignment: TabAlignment.values[0],
      controller: _tabController,
      isScrollable: true,
      labelColor: isDark ? AppPallete.whiteColor : AppPallete.backgroundColor,
      indicatorColor: AppPallete.green,
      padding: const EdgeInsets.symmetric(vertical: 15),
      tabs: const [
        Text(
          tMusicRelated,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        Text(
          tDhammaRelated,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ],
    );
  }
}
