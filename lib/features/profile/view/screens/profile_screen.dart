import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/features/download/view/widgets/downloaded_list_playlist_widget.dart';
import 'package:path_provider/path_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<List<Directory>> _foldersFuture;

  Future<List<Directory>> _getDownloadedFolders() async {
    final directory = await getApplicationDocumentsDirectory();
    final downloadDir = Directory(directory.path);
    final folders = downloadDir.listSync().whereType<Directory>().toList();
    return folders;
  }

  @override
  void initState() {
    super.initState();
    _foldersFuture = _getDownloadedFolders();
  }

  bool _isVisible = false;
  String selectedWidget = '';
  Map<String, Widget> profileWidgets = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Downloads'),
      ),
      body: Stack(
        children: [
          FutureBuilder<List<Directory>>(
            future: _foldersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                    child: Text('No downloaded folders found!'));
              } else {
                final folders = snapshot.data!;
                debugPrint('Folders: $folders');
                return folders.length > 1
                    ? ListView.builder(
                        itemCount: folders.length,
                        itemBuilder: (context, index) {
                          final folder = folders[index];
                          final folderName = folder.path.split('/').last;
                          debugPrint('Folder Name----: $folderName');

                          if (folderName == 'flutter_assets') {
                            return const SizedBox();
                          }
                          return ListTile(
                            leading: const Icon(
                              Icons.folder,
                              size: 60,
                            ),
                            title: Text(folder.path.split('/').last),
                            onTap: () {
                              setState(() {
                                profileWidgets[folderName] =
                                    DownloadedListPlaylistWidget(
                                  folderName: folderName,
                                );
                                selectedWidget = folderName;
                                _isVisible = true;
                              });
                            },
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          "No downloaded tracks to show.",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
              }
            },
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            right: _isVisible ? 0 : -MediaQuery.of(context).size.width,
            top: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: AppPallete.backgroundColor,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isVisible = false;
                            selectedWidget = '';
                          });
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      Text(
                        'In $selectedWidget',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.sort),
                      ),
                    ],
                  ),
                  profileWidgets[selectedWidget] ?? const SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
