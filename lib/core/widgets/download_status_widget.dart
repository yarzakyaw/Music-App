import 'package:flutter/material.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/features/download/viewmodel/download_view_model.dart';

class DownloadStatusWidget extends StatelessWidget {
  const DownloadStatusWidget({
    super.key,
    required this.downloadViewModel,
  });

  final DownloadViewModel downloadViewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 105,
        decoration: BoxDecoration(
          border: Border.all(color: AppPallete.greyColor),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: ValueListenableBuilder<String>(
                valueListenable: downloadViewModel.currentTrackStatusHeader,
                builder: (context, status, child) {
                  return Text(status);
                },
              ),
            ),
            ValueListenableBuilder<String>(
              valueListenable: downloadViewModel.currentTrackStatusBody,
              builder: (context, status, child) {
                return Text(status);
              },
            ),
            ValueListenableBuilder<double>(
              valueListenable: downloadViewModel.progressNotifier,
              builder: (context, progress, child) {
                return progress < 1.0
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                              right: 8.0,
                              top: 8.0,
                            ),
                            child: LinearProgressIndicator(
                              value: progress,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            '${(progress * 100).toStringAsFixed(0)}%',
                          ),
                        ],
                      )
                    : const SizedBox();
              },
            ),
            /* if (downloadViewModel.currentTrackStatusBody.value.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Text(downloadViewModel.currentTrackStatusBody.value),
          ), */
          ],
        ),
      ),
    );
  }
}
