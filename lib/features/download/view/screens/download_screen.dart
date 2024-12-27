import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/widgets/download_status_widget.dart';
import 'package:mingalar_music_app/core/widgets/download_track_widget.dart';
import 'package:mingalar_music_app/features/download/viewmodel/download_view_model.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';

class DownloadScreen extends ConsumerStatefulWidget {
  final String playlistTitle;
  final List<MusicModel> playlist;

  const DownloadScreen({
    super.key,
    required this.playlist,
    required this.playlistTitle,
  });

  @override
  ConsumerState<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends ConsumerState<DownloadScreen> {
  Future<void> _downloadMusic(MusicModel track) async {
    final downloadViewModel = ref.read(downloadViewModelProvider.notifier);
    await downloadViewModel.downloadFile(track);
  }

  Future<void> _downloadPlaylist(
      List<MusicModel> playlist, String playlistName) async {
    final downloadViewModel = ref.read(downloadViewModelProvider.notifier);
    await downloadViewModel.downloadPlaylist(playlist, playlistName);
  }

  @override
  Widget build(BuildContext context) {
    final downloadViewModel = ref.watch(downloadViewModelProvider.notifier);
    final downloadState = ref.watch(downloadViewModelProvider);
    // ref.watch(downloadViewModelProvider);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Find in ${widget.playlistTitle}',
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Divider(indent: 30, endIndent: 30, thickness: 3),
            ),
            /* downloadState != null && downloadState.isLoading
                ? DownloadStatusWidget(
                    progress: downloadViewModel.progress,
                    progressMessageTitle:
                        downloadViewModel.ProgressMessageTitle,
                    progressMessage: downloadViewModel.ProgressMessageBody,
                  )
                :  */
            /* DownloadStatusWidget(
              progress: downloadViewModel.progress,
              progressMessageTitle: downloadViewModel.ProgressMessageTitle,
              progressMessage: downloadViewModel.ProgressMessageBody,
            ), */
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                bottom: 16.0,
              ),
              child: GestureDetector(
                onTap: () => _downloadPlaylist(
                  widget.playlist,
                  widget.playlistTitle,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppPallete.greyColor),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Center(
                    child: Text(
                      'Download the whole playlist',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            downloadState != null && downloadState.isLoading
                ? DownloadStatusWidget(downloadViewModel: downloadViewModel)
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 0),
              child: SizedBox(
                height: 390,
                child: ListView.builder(
                  itemCount: widget.playlist.length,
                  itemBuilder: (context, index) {
                    final track = widget.playlist[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: DownloadTrackWidget(
                        track: track,
                        onPressed: () => _downloadMusic(track),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 380),
          ],
        ),
      ),
    );
  }
}

/* import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/widgets/download_status_widget.dart';
import 'package:mingalar_music_app/core/widgets/download_track_widget.dart';
import 'package:mingalar_music_app/features/download/viewmodel/download_view_model.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';

class DownloadScreen extends ConsumerStatefulWidget {
  final String playlistTitle;
  final List<MusicModel> playlist;

  const DownloadScreen({
    super.key,
    required this.playlist,
    required this.playlistTitle,
  });

  @override
  ConsumerState<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends ConsumerState<DownloadScreen> {
  Future<void> _downloadMusic(MusicModel track) async {
    final downloadViewModel = ref.read(downloadViewModelProvider.notifier);
    await downloadViewModel.downloadFile(track);
  }

  Future<void> _downloadPlaylist(
      List<MusicModel> playlist, String playlistName) async {
    final downloadViewModel = ref.read(downloadViewModelProvider.notifier);
    await downloadViewModel.downloadPlaylist(playlist, playlistName);
  }

  @override
  Widget build(BuildContext context) {
    final downloadViewModel = ref.watch(downloadViewModelProvider.notifier);
    // final downloadState = ref.watch(downloadViewModelProvider);
    ref.watch(downloadViewModelProvider);

    debugPrint(downloadViewModel.progress.toString());
    debugPrint(downloadViewModel.ProgressMessageBody);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Find ${widget.playlistTitle}',
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Divider(indent: 30, endIndent: 30, thickness: 3),
            ),
            /* downloadState != null && downloadState.isLoading
                ? DownloadStatusWidget(
                    progress: downloadViewModel.progress,
                    progressMessageTitle:
                        downloadViewModel.ProgressMessageTitle,
                    progressMessage: downloadViewModel.ProgressMessageBody,
                  )
                :  */
            DownloadStatusWidget(
              progress: downloadViewModel.progress,
              progressMessageTitle: downloadViewModel.ProgressMessageTitle,
              progressMessage: downloadViewModel.ProgressMessageBody,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                bottom: 16.0,
              ),
              child: GestureDetector(
                onTap: () => _downloadPlaylist(
                  widget.playlist,
                  widget.playlistTitle,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppPallete.greyColor),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Center(
                    child: Text(
                      'Download the whole playlist',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 0),
              child: SizedBox(
                height: 390,
                child: ListView.builder(
                  itemCount: widget.playlist.length,
                  itemBuilder: (context, index) {
                    final track = widget.playlist[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: DownloadTrackWidget(
                        track: track,
                        onPressed: () => _downloadMusic(track),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 380),
          ],
        ),
      ),
    );
  }
} */


/* import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/widgets/download_track_widget.dart';
import 'package:mingalar_music_app/features/download/viewmodel/download_view_model.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';

class DownloadScreen extends ConsumerStatefulWidget {
  final String playlistTitle;
  final List<MusicModel> playlist;

  const DownloadScreen({
    super.key,
    required this.playlist,
    required this.playlistTitle,
  });

  @override
  ConsumerState<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends ConsumerState<DownloadScreen> {
  Future<void> _downloadMusic(MusicModel track) async {
    final downloadViewModel = ref.read(downloadViewModelProvider.notifier);
    await downloadViewModel.downloadFile(track);
  }

  Future<void> _downloadPlaylist(
      List<MusicModel> playlist, String playlistName) async {
    final downloadViewModel = ref.read(downloadViewModelProvider.notifier);
    await downloadViewModel.downloadPlaylist(playlist, playlistName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Find in this Playlist',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Divider(indent: 30, endIndent: 30, thickness: 3),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0),
              child: GestureDetector(
                onTap: () {
                  _downloadPlaylist(widget.playlist, widget.playlistTitle);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppPallete.greyColor),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Center(
                    child: Text(
                      'Download the whole playlist',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 0),
              child: SizedBox(
                height: 390,
                child: ListView.builder(
                  itemCount: widget.playlist.length,
                  itemBuilder: (context, index) {
                    final track = widget.playlist[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: DownloadTrackWidget(
                        track: track,
                        onPressed: () => _downloadMusic(track),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 380),
          ],
        ),
      ),
    );
  }
}
 */
