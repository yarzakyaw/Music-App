import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/models/user_defined_playlist_model.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';
import 'package:mingalar_music_app/features/libraryMusicPlaylist/repositories/user_generated_playlists_repository.dart';

class AddToPlaylistTrackWidget extends ConsumerStatefulWidget {
  final MusicModel track;
  final UserDefinedPlaylistModel playlist;
  const AddToPlaylistTrackWidget({
    super.key,
    required this.track,
    required this.playlist,
  });

  @override
  ConsumerState<AddToPlaylistTrackWidget> createState() =>
      _AddToPlaylistTrackWidgetState();
}

class _AddToPlaylistTrackWidgetState
    extends ConsumerState<AddToPlaylistTrackWidget> {
  late bool isTrackInPlaylist;

  @override
  void initState() {
    super.initState();
    isTrackInPlaylist =
        widget.playlist.tracks.any((t) => t.id == widget.track.id);
  }

  void _addTrackToPlaylist() {
    try {
      ref
          .watch(userGeneratedPlaylistsRepositoryProvider)
          .addTracksToPlaylist(widget.playlist.id, widget.track);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.track.musicName} added to playlist'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() {
      isTrackInPlaylist = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        trailing: isTrackInPlaylist
            ? null
            : IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: _addTrackToPlaylist,
              ),
      ),
    );
  }
}
