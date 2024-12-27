import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mingalar_music_app/core/constants/image_strings.dart';
import 'package:mingalar_music_app/core/constants/text_strings.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/features/onboarding/view/widgets/basic_app_button.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            decoration: const BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(iOnboarding1),
            )),
          ),
          Container(color: Colors.black.withOpacity(0.15)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(iLogo),
                ),
                const Spacer(),
                const Text(
                  tOnboarding1Header,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppPallete.whiteColor,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 21),
                const Text(
                  tOnboarding1Body,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppPallete.greyColor,
                      fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                BasicAppButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      'SigninScreen',
                    );
                  },
                  title: tGetStarted,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
