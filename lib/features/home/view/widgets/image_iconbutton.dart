import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';

class ImageIconbutton extends StatelessWidget {
  final bool edit;
  const ImageIconbutton({
    super.key,
    this.edit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppPallete.greyColor, width: 2),
          ),
          child: const CircleAvatar(
            maxRadius: 60,
            backgroundColor: AppPallete.transparentColor,
            child: ClipOval(
              child: Icon(
                LineAwesomeIcons.user,
                size: 100,
                color: AppPallete.greyColor,
              ),
            ),
          ),
        ),
        edit == true
            ? Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      LineAwesomeIcons.image_solid,
                      size: 20,
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
