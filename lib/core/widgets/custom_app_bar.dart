import 'package:flutter/material.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? action;
  final Color? backgroundColor;
  final bool hideBack;

  const CustomAppBar({
    super.key,
    this.title,
    this.action,
    this.backgroundColor,
    this.hideBack = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: title ?? const Text(''),
      actions: [action ?? Container()],
      leading: hideBack
          ? null
          : IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: isDark
                        ? AppPallete.whiteColor.withOpacity(0.03)
                        : AppPallete.backgroundColor.withOpacity(0.04),
                    shape: BoxShape.circle),
                child: Icon(
                  Icons.arrow_back_sharp,
                  size: 20,
                  color: isDark
                      ? AppPallete.whiteColor
                      : AppPallete.backgroundColor,
                ),
              ),
            ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
