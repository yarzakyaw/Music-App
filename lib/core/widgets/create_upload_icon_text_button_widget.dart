import 'package:flutter/cupertino.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';

class CreateUploadIconTextButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String title;

  const CreateUploadIconTextButtonWidget({
    super.key,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: AppPallete.greyColor,
                // border: Border.all(color: AppPallete.borderColor),
                shape: BoxShape.circle,
              ),
              child: const Icon(CupertinoIcons.plus, size: 30),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
