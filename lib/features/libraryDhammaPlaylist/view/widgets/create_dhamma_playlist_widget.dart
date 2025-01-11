import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/models/user_defined_playlist_model.dart';
import 'package:mingalar_music_app/core/providers/current_user_notifier.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/features/libraryDhammaPlaylist/repositories/user_generated_dhamma_playlists_repository.dart';
import 'package:mingalar_music_app/core/widgets/music_list_usergen_playlist_widget.dart';
import 'package:uuid/uuid.dart';

class CreateDhammaPlaylistWidget extends ConsumerStatefulWidget {
  const CreateDhammaPlaylistWidget({super.key});

  @override
  ConsumerState<CreateDhammaPlaylistWidget> createState() =>
      _CreateDhammaPlaylistWidgetState();
}

class _CreateDhammaPlaylistWidgetState
    extends ConsumerState<CreateDhammaPlaylistWidget> {
  final playlistName = TextEditingController(
    text: 'My Dhamma Playlist #1',
  );
  final playlistDescription = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  List<String> predefinedHashtags = [
    '#Abhidharma',
    '#Sutra',
    '#Vienna',
    '#Meditation',
    '#Vipassana',
  ];
  List<String> selectedHashtags = [];

  @override
  void didChangeDependencies() {
    // Automatically focus and display keyboard when the panel opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_focusNode.hasFocus) return; // Avoid multiple requests
      _focusNode.requestFocus();
      playlistName.selection = TextSelection(
        baseOffset: 0,
        extentOffset: playlistName.text.length,
      );
    });
    super.didChangeDependencies();
  }

  // Method to add or remove hashtags
  void toggleHashtag(String hashtag) {
    setState(() {
      if (selectedHashtags.contains(hashtag)) {
        selectedHashtags.remove(hashtag);
      } else {
        selectedHashtags.add(hashtag);
      }
    });
  }

  // Method to create a new hashtag
  void addNewHashtag(String newHashtag) {
    if (newHashtag.isNotEmpty && !selectedHashtags.contains(newHashtag)) {
      setState(() {
        selectedHashtags.add(newHashtag);
      });
    }
  }

  @override
  void dispose() {
    playlistName.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Name your playlist',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: playlistName,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  // hintText: 'My playlist #1',
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  filled: true,
                ),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
              TextField(
                controller: playlistDescription,
                decoration: InputDecoration(
                  hintText: 'Description (optional)',
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  filled: true,
                ),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
              const Text(
                'Hashtags',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                children: predefinedHashtags.map((hashtag) {
                  return ChoiceChip(
                    label: Text(hashtag),
                    selected: selectedHashtags.contains(hashtag),
                    onSelected: (selected) {
                      toggleHashtag(hashtag);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Add a new hashtag',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  addNewHashtag(value);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final newPlaylist = UserDefinedPlaylistModel(
                    tracks: [],
                    id: Uuid().v4(),
                    title: playlistName.text,
                    description: playlistDescription.text,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                    createrId: currentUser!.userDetails!.uid,
                    creatorName: currentUser.username,
                    hashtags: selectedHashtags,
                    likeCount: 0,
                    isShared: false,
                  );
                  try {
                    ref
                        .watch(userGeneratedDhammaPlaylistsRepositoryProvider)
                        .createPlaylist(newPlaylist);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MusicListUsergenPlaylistWidget(
                          playlist: newPlaylist,
                        ),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: AppPallete.borderColor),
                child: Text(
                  'Create',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
