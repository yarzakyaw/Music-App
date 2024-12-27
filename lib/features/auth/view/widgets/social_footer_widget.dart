import 'package:flutter/material.dart';
import 'package:mingalar_music_app/core/constants/image_strings.dart';
import 'package:mingalar_music_app/core/constants/text_strings.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/features/auth/view/widgets/clickable_richtext_widget.dart';
import 'package:mingalar_music_app/features/auth/view/widgets/social_button_widget.dart';

class SocialFooterWidget extends StatelessWidget {
  final String text1, text2;
  final VoidCallback onPressed;
  const SocialFooterWidget({
    super.key,
    this.text1 = tDontHaveAnAccount,
    this.text2 = tSignupBody,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        SocialButtonWidget(
          image: iGoogleLogo,
          foreground: AppPallete.googleForegroundColor,
          background: AppPallete.googleBgColor,
          text: '$tConnectWith $tGoogle',
          isLoading: false,
          onPressed: () {},
        ),
        const SizedBox(height: 10),
        SocialButtonWidget(
          image: iFacebookLogo,
          foreground: AppPallete.whiteColor,
          background: AppPallete.facebookForegroundColor,
          text: '$tConnectWith $tFacebook',
          isLoading: false,
          onPressed: () {},
        ),
        const SizedBox(height: 15),
        ClickableRichtextWidget(
          text1: text1,
          text2: text2,
          onPressed: onPressed,
        ),
      ],
    );
  }
}
