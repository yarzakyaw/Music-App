import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/providers/favorite_artist_notifier.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/widgets/create_upload_icon_text_button_widget.dart';
import 'package:mingalar_music_app/features/home/models/artist_model.dart';

class LibraryArtistsScreen extends ConsumerStatefulWidget {
  const LibraryArtistsScreen({super.key});

  @override
  ConsumerState<LibraryArtistsScreen> createState() =>
      _LibraryArtistsScreenState();
}

class _LibraryArtistsScreenState extends ConsumerState<LibraryArtistsScreen> {
  bool _isVisible = false;
  String selectedWidget = '';
  String selectedWidgetTitle = '';
  Map<String, Widget> libraryArtistsWidgets = {};

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final Map<String, ArtistModel> favorites =
        ref.watch(favoriteArtistNotifierProvider);

    return Stack(
      children: [
        Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final artist = favorites[favorites.keys.elementAt(index)];
                return GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      bottom: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Image(
                                  image: NetworkImage(artist!.profileImageUrl),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              artist.nameENG,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            CreateUploadIconTextButtonWidget(
              onTap: () {},
              title: 'Add More Artists',
            ),
          ],
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          right: _isVisible ? 0 : -screenWidth,
          top: 0,
          child: Container(
            width: screenWidth,
            height: screenHeight,
            color: AppPallete.backgroundColor,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isVisible = !_isVisible;
                        });
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Text(
                      selectedWidgetTitle,
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
                libraryArtistsWidgets[selectedWidget] ?? const SizedBox(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
