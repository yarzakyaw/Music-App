import 'package:flutter/cupertino.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';

class PlaylistIconWidget extends StatelessWidget {
  final int count;
  final String title;
  final List<Color>? colors;

  const PlaylistIconWidget({
    super.key,
    required this.count,
    required this.title,
    this.colors = const [
      AppPallete.gradient1,
      AppPallete.gradient2,
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: colors!,
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                  // border: Border.all(color: AppPallete.borderColor),
                  shape: BoxShape.rectangle,
                ),
                child: const Icon(CupertinoIcons.heart, size: 30),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Playlist - $count track(s)',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
