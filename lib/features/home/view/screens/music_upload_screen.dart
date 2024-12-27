import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/constants/text_strings.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/utils.dart';
import 'package:mingalar_music_app/core/widgets/customfield_widget.dart';
import 'package:mingalar_music_app/core/widgets/loader.dart';
import 'package:mingalar_music_app/features/home/view/widgets/add_album.dart';
import 'package:mingalar_music_app/features/home/view/widgets/audio_wave.dart';
import 'package:mingalar_music_app/features/home/viewmodel/home_view_model.dart';

class MusicUploadScreen extends ConsumerStatefulWidget {
  const MusicUploadScreen({super.key});

  @override
  ConsumerState<MusicUploadScreen> createState() => _MusicUploadScreenState();
}

class _MusicUploadScreenState extends ConsumerState<MusicUploadScreen> {
  final musicNameController = TextEditingController();
  final artistIdController = TextEditingController();
  final artistNameMMController = TextEditingController();
  final featuringController = TextEditingController();
  final albumIdController = TextEditingController();
  final creditToController = TextEditingController();
  final audioTypeController = TextEditingController(text: tMusic);
  Color selectedColor = AppPallete.cardColor;
  File? selectedImage;
  File? selectedAudio;
  final formKey = GlobalKey<FormState>();

  DateTime? selectedDate;

  List<String> allArtists = ['Select One'];
  Map<String, String> artistNameId = {};
  Map<String, String> artistNameMM = {};
  String selectedArtist = 'Select One';

  List<String> allAlbumbByArtist = ['Select One'];
  Map<String, String> albumNameId = {};
  String selectedAlbum = 'Select One';

  List<String> allGenres = ['Select One'];
  String selectedGenre = 'Select One';

  List<String> allDownloadOptions = ['Select One', 'Free', 'Paid'];
  String selectedDownloadOption = 'Select One';

  List<String> predefinedHashtags = ['#Pop', '#Rock', '#HipHop', '#Jazz'];
  List<String> selectedHashtags = [];

  void selectAudio() async {
    final pickedAudio = await pickAudio();
    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    }
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
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
    super.dispose();
    musicNameController.dispose();
    artistIdController.dispose();
    albumIdController.dispose();
    featuringController.dispose();
    artistNameMMController.dispose();
    audioTypeController.dispose();
    creditToController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(homeViewModelProvider.select((val) => val?.isLoading == true));

    ref.watch(getAllArtistsProvider).whenData((artists) {
      debugPrint(artists.toString());

      for (final artist in artists) {
        final artistName = artist.nameENG;
        if (!allArtists.contains(artistName)) {
          allArtists.add(artistName);
          artistNameId[artistName] = artist.id;
          artistNameMM[artistName] = artist.nameMM;
        }
      }
      debugPrint("Total artists: ${allArtists.length}");
    });

    String? selectedArtistId = artistNameId[selectedArtist];
    if (selectedArtistId != null && selectedArtist != 'Select One') {
      ref.watch(getAlbumsByArtistProvider(selectedArtistId)).whenData((albums) {
        debugPrint('albums:---------------${albums.toList()}');
        for (final album in albums) {
          if (!allAlbumbByArtist.contains(album.albumName)) {
            allAlbumbByArtist.add(album.albumName);
            albumNameId[album.albumName] = album.id;
          }
        }
        setState(() {});
      });
    }

    ref.watch(getAllGenresProvider).whenData((genres) {
      debugPrint(genres.toString());

      for (final genre in genres) {
        final genreName = genre.name;
        if (!allGenres.contains(genreName)) {
          allGenres.add(genreName);
        }
      }
      debugPrint("Total genres: ${allGenres.length}");
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(tUploadMusic),
        actions: [
          IconButton(
            onPressed: () async {
              if (formKey.currentState!.validate() &&
                  selectedAudio != null &&
                  selectedImage != null) {
                ref.read(homeViewModelProvider.notifier).uploadMusic(
                      selectedAudio: selectedAudio!,
                      selectedThumbnail: selectedImage!,
                      musicName: musicNameController.text,
                      audioType: audioTypeController.text,
                      artist: selectedArtist,
                      artistMM: artistNameMMController.text,
                      genre: selectedGenre,
                      artistId: artistIdController.text,
                      albumId: albumIdController.text,
                      albumName: selectedAlbum,
                      featuring: featuringController.text,
                      releaseDate: selectedDate!,
                      downloadOption: selectedDownloadOption,
                      creditTo: creditToController.text,
                      selectedColor: selectedColor,
                      hashtags: selectedHashtags,
                    );
              } else {
                showSnackBar(context, tMissingFields);
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ------ Image -----
                      GestureDetector(
                        onTap: selectImage,
                        child: selectedImage != null
                            ? SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : DottedBorder(
                                color: AppPallete.borderColor,
                                radius: const Radius.circular(10),
                                borderType: BorderType.RRect,
                                dashPattern: const [10, 4],
                                strokeCap: StrokeCap.round,
                                child: const SizedBox(
                                  height: 159,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open,
                                        size: 40,
                                      ),
                                      SizedBox(height: 15),
                                      Text(
                                        tSelectThumbnail,
                                        style: TextStyle(fontSize: 15),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        tMusic,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // ------ Audio -----
                      selectedAudio != null
                          ? AudioWave(path: selectedAudio!.path)
                          : CustomfieldWidget(
                              hintText: tPickSong,
                              controller: null,
                              readOnly: true,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return tAudioMissing;
                                }
                                return null;
                              },
                              onTap: selectAudio,
                            ),
                      const SizedBox(height: 20),
                      // --- Song ---
                      CustomfieldWidget(
                        hintText: tMusicName,
                        controller: musicNameController,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return tMusicNameMissing;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // ------ Audio Type -----
                      const Text(
                        tAudioType,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomfieldWidget(
                        hintText: tMusic,
                        controller: audioTypeController,
                        readOnly: true,
                      ),
                      const SizedBox(height: 10),
                      // ------ Genre -----
                      const Text(
                        tGenre,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              validator: (value) {
                                if (value == null) {
                                  return tSelectGenre;
                                } else {
                                  return null;
                                }
                              },
                              isExpanded: true,
                              items: allGenres.map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem),
                                );
                              }).toList(),
                              onChanged: (value) {
                                selectedGenre = value!;
                              },
                              value: selectedGenre,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'AddGenreScreen');
                            },
                            icon: const Icon(
                              Icons.add_box,
                              size: 50,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // ------ Hashtags -----
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
                      const SizedBox(height: 10),
                      // ------ Artist -----
                      const Text(
                        tArtist,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              validator: (value) {
                                if (value == null) {
                                  return tSelectArtist;
                                } else {
                                  return null;
                                }
                              },
                              isExpanded: true,
                              items:
                                  allArtists.map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem),
                                );
                              }).toList(),
                              onChanged: (value) {
                                _onSelected(value!);
                              },
                              value: selectedArtist,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'AddArtistScreen');
                            },
                            icon: const Icon(
                              Icons.add_box,
                              size: 50,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomfieldWidget(
                        hintText: tArtistId,
                        controller: artistIdController,
                        readOnly: true,
                      ),
                      const SizedBox(height: 20),
                      CustomfieldWidget(
                        hintText: tArtistMM,
                        controller: artistNameMMController,
                        readOnly: true,
                      ),
                      const SizedBox(height: 20),
                      CustomfieldWidget(
                        hintText: tFeatureing,
                        controller: featuringController,
                      ),
                      const SizedBox(height: 10),
                      // ------ Album -----
                      const Text(
                        tAlbum,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              validator: (value) {
                                if (value == null) {
                                  return tSelectAlbum;
                                } else {
                                  return null;
                                }
                              },
                              isExpanded: true,
                              items: allAlbumbByArtist
                                  .map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem),
                                );
                              }).toList(),
                              onChanged: (value) {
                                _onAlbumSelected(value!);
                              },
                              value: selectedAlbum,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddAlbum(
                                    artistId: artistIdController.text,
                                    artistNameENG: selectedArtist,
                                    artistNameMM: artistNameMMController.text,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.add_box,
                              size: 50,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomfieldWidget(
                        hintText: tAlbum,
                        controller: albumIdController,
                        readOnly: true,
                      ),
                      const SizedBox(height: 10),
                      // ------ Download Option -----
                      const Text(
                        tDownloadOption,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        validator: (value) {
                          if (value == null) {
                            return tSelectDownloadOption;
                          } else {
                            return null;
                          }
                        },
                        isExpanded: true,
                        items:
                            allDownloadOptions.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        onChanged: (value) {
                          selectedDownloadOption = value!;
                        },
                        value: selectedDownloadOption,
                      ),
                      const SizedBox(height: 10),
                      // --- Credit to ---
                      CustomfieldWidget(
                        hintText: tCreditTo,
                        controller: creditToController,
                      ),
                      // ------ Date -----
                      const SizedBox(height: 10),
                      const Text(
                        tReleaseDate,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 70,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 15),
                        decoration: BoxDecoration(
                          border: Border.all(width: 3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDate == null
                                  ? tNoDateChosen
                                  : 'Picked Date: ${'${selectedDate!.toLocal()}'.split(' ')[0]}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            GestureDetector(
                              onTap: () => _selectDate(context),
                              child: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ColorPicker(
                        pickersEnabled: const {
                          ColorPickerType.wheel: true,
                        },
                        color: selectedColor,
                        onColorChanged: (Color color) {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void _onSelected(String value) async {
    setState(() {
      selectedArtist = value;
      artistIdController.text = artistNameId[value]!;
      artistNameMMController.text = artistNameMM[value]!;
      allAlbumbByArtist = ['Select One'];
      selectedAlbum = 'Select One';

      debugPrint('artist id:---------------${artistIdController.text}');
    });

    final artistId = artistNameId[selectedArtist]!.toString();
    debugPrint('artistId:---------------$artistId');
  }

  void _onAlbumSelected(String value) {
    setState(() {
      selectedAlbum = value;
      albumIdController.text = albumNameId[value]!;
    });
  }
}
