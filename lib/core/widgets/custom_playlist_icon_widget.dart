import 'package:flutter/cupertino.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';

class CustomPlaylistIconWidget extends StatelessWidget {
  final String title;
  final String description;

  const CustomPlaylistIconWidget({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppPallete.greyColor,
                  // border: Border.all(color: AppPallete.borderColor),
                  shape: BoxShape.rectangle,
                ),
                child: const Icon(
                  CupertinoIcons.music_note_list,
                  size: 30,
                ),
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
                    description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
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
