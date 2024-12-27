import 'package:flutter/material.dart';
import 'package:mingalar_music_app/core/constants/text_strings.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/features/libraryArtists/view/screens/library_artists_screen.dart';
import 'package:mingalar_music_app/features/libraryBhikkhus/view/screens/library_bhikkhus_screen.dart';
import 'package:mingalar_music_app/features/libraryMusicPlaylist/view/screens/library_music_playlist_screen.dart';
import 'package:mingalar_music_app/features/libraryDhammaPlaylist/view/screens/library_dhamma_playlist_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  bool isMusicPlaylistSelected = true;
  bool isDhammaPlaylistSelected = false;
  bool isArtistSelected = false;
  bool isBhikkhuSelected = false;

  int selectedView = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> pageViews = [
      const LibraryMusicPlaylistScreen(),
      const LibraryDhammaPlaylistScreen(),
      const LibraryArtistsScreen(),
      const LibraryBhikkhusScreen(),
    ];

    return Column(
      children: [
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedView = 0;
                      isMusicPlaylistSelected = true;
                      isDhammaPlaylistSelected = false;
                      isArtistSelected = false;
                      isBhikkhuSelected = false;
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 140,
                    decoration: BoxDecoration(
                      color: isMusicPlaylistSelected == true
                          ? AppPallete.greenColor
                          : AppPallete.greyColor,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: isMusicPlaylistSelected == true
                            ? AppPallete.greenColor
                            : AppPallete.greyColor,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        tMusicPlaylists,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isMusicPlaylistSelected == true
                              ? AppPallete.whiteColor
                              : AppPallete.backgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedView = 1;
                      isMusicPlaylistSelected = false;
                      isDhammaPlaylistSelected = true;
                      isArtistSelected = false;
                      isBhikkhuSelected = false;
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 140,
                    decoration: BoxDecoration(
                      color: isDhammaPlaylistSelected == true
                          ? AppPallete.greenColor
                          : AppPallete.greyColor,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: isDhammaPlaylistSelected == true
                            ? AppPallete.greenColor
                            : AppPallete.greyColor,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        tDhammaPlaylists,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDhammaPlaylistSelected == true
                              ? AppPallete.whiteColor
                              : AppPallete.backgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedView = 2;
                      isMusicPlaylistSelected = false;
                      isDhammaPlaylistSelected = false;
                      isArtistSelected = true;
                      isBhikkhuSelected = false;
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 140,
                    decoration: BoxDecoration(
                      color: isArtistSelected == true
                          ? AppPallete.greenColor
                          : AppPallete.greyColor,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: isArtistSelected == true
                            ? AppPallete.greenColor
                            : AppPallete.greyColor,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        tArtists,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isArtistSelected == true
                              ? AppPallete.whiteColor
                              : AppPallete.backgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedView = 3;
                      isMusicPlaylistSelected = false;
                      isDhammaPlaylistSelected = false;
                      isArtistSelected = false;
                      isBhikkhuSelected = true;
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 140,
                    decoration: BoxDecoration(
                      color: isBhikkhuSelected == true
                          ? AppPallete.greenColor
                          : AppPallete.greyColor,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: isBhikkhuSelected == true
                            ? AppPallete.greenColor
                            : AppPallete.greyColor,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        tBhikkhus,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isBhikkhuSelected == true
                              ? AppPallete.whiteColor
                              : AppPallete.backgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Flexible(child: pageViews[selectedView]),
      ],
    );
  }
}
