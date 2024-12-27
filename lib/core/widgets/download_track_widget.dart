import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/features/download/viewmodel/download_view_model.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';

class DownloadTrackWidget extends ConsumerStatefulWidget {
  final MusicModel track;
  final VoidCallback onPressed;

  const DownloadTrackWidget({
    super.key,
    required this.track,
    required this.onPressed,
  });

  @override
  ConsumerState<DownloadTrackWidget> createState() =>
      _DownloadTrackWidgetState();
}

class _DownloadTrackWidgetState extends ConsumerState<DownloadTrackWidget> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final downloadState = ref.watch(downloadViewModelProvider);
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        title: Text(
          widget.track.musicName,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(widget.track.artist),
        leading: Container(
          width: 56,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                widget.track.thumbnailUrl,
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              bottomLeft: Radius.circular(4),
            ),
          ),
        ),
        trailing: downloadState != null && downloadState.isLoading
            ? const SizedBox()
            : IconButton(
                icon: const Icon(Icons.download),
                onPressed: widget.onPressed,
              ),
      ),
    );
  }
}


/* import 'package:flutter/material.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';

class DownloadTrackWidget extends StatelessWidget {
  final MusicModel track;
  final VoidCallback onPressed;

  const DownloadTrackWidget({
    super.key,
    required this.track,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade700,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        title: Text(
          track.musicName,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(track.artist),
        leading: Container(
          width: 56,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                track.thumbnailUrl,
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              bottomLeft: Radius.circular(4),
            ),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.download),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
 */