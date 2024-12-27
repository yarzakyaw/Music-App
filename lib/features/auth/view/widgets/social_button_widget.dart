import 'package:flutter/material.dart';
import 'package:mingalar_music_app/features/auth/view/widgets/loading_text_indicator_widget.dart';

class SocialButtonWidget extends StatelessWidget {
  final String text;
  final String image;
  final Color foreground, background;
  final VoidCallback onPressed;
  final bool isLoading;
  const SocialButtonWidget({
    super.key,
    required this.text,
    required this.image,
    required this.foreground,
    required this.background,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: foreground,
          backgroundColor: background,
          side: BorderSide.none,
        ),
        icon: isLoading
            ? const SizedBox()
            : Image(
                image: AssetImage(image),
                width: 24,
                height: 24,
              ),
        label: isLoading
            ? const LoadingTextIndicatorWidget()
            : Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge!.apply(
                      color: foreground,
                    ),
              ),
      ),
    );
  }
}
