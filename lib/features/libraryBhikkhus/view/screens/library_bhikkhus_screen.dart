import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/providers/favorite_bhikkhu_notifier.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/widgets/create_upload_icon_text_button_widget.dart';
import 'package:mingalar_music_app/features/dhamma/models/bhikkhu_model.dart';

class LibraryBhikkhusScreen extends ConsumerStatefulWidget {
  const LibraryBhikkhusScreen({super.key});

  @override
  ConsumerState<LibraryBhikkhusScreen> createState() =>
      _LibraryBhikkhusScreenState();
}

class _LibraryBhikkhusScreenState extends ConsumerState<LibraryBhikkhusScreen> {
  bool _isVisible = false;
  String selectedWidget = '';
  String selectedWidgetTitle = '';
  Map<String, Widget> libraryBhikkhusWidgets = {};

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final Map<String, BhikkhuModel> favorites =
        ref.watch(favoriteBhikkhuNotifierProvider);

    return Stack(
      children: [
        Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final bhikkhu = favorites[favorites.keys.elementAt(index)];
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
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    bhikkhu!.profileImageUrl,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bhikkhu.nameMM,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  bhikkhu.alias,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
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
              title: 'Add More Bhikkhus',
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
                libraryBhikkhusWidgets[selectedWidget] ?? const SizedBox(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
