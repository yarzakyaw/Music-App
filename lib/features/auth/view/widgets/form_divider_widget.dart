import 'package:flutter/material.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/constants/text_strings.dart';

class FormDividerWidget extends StatelessWidget {
  const FormDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final lineColor = isDark ? AppPallete.gradient2 : AppPallete.gradient4;
    return Row(
      children: [
        Flexible(
          child: Divider(
            thickness: 1,
            indent: 50,
            color: lineColor.withOpacity(0.3),
            endIndent: 10,
          ),
        ),
        Text(
          tOr,
          style: Theme.of(context).textTheme.bodyLarge!.apply(
                color: isDark
                    ? AppPallete.whiteColor.withOpacity(0.5)
                    : AppPallete.backgroundColor.withOpacity(0.5),
              ),
        ),
        Flexible(
          child: Divider(
            thickness: 1,
            indent: 10,
            color: lineColor.withOpacity(0.3),
            endIndent: 50,
          ),
        ),
      ],
    );
  }
}
