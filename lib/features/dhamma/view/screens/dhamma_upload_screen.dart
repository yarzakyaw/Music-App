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
import 'package:mingalar_music_app/features/dhamma/view/widgets/add_collection.dart';
import 'package:mingalar_music_app/features/dhamma/viewmodel/dhamma_view_model.dart';
import 'package:mingalar_music_app/features/home/view/widgets/audio_wave.dart';

class DhammaUploadScreen extends ConsumerStatefulWidget {
  const DhammaUploadScreen({super.key});

  @override
  ConsumerState<DhammaUploadScreen> createState() => _DhammaUploadScreenState();
}

class _DhammaUploadScreenState extends ConsumerState<DhammaUploadScreen> {
  final trackNameController = TextEditingController();
  final bhikkhuIdController = TextEditingController();
  final bhikkhuNameENGController = TextEditingController();
  final aliasController = TextEditingController();
  final titleController = TextEditingController();
  final collectionIdController = TextEditingController();
  final creditToController = TextEditingController();
  final audioTypeController = TextEditingController(text: tDhamma);
  Color selectedColor = AppPallete.cardColor;
  File? selectedImage;
  File? selectedAudio;
  String? bhikkhuProfileImageUrl;
  final formKey = GlobalKey<FormState>();

  DateTime? selectedDate;

  List<String> allBhikkhus = ['Select One'];
  Map<String, String> bhikkhuNameId = {};
  Map<String, String> bhikkhuNameENG = {};
  String selectedBhikkhu = 'Select One';

  List<String> allCollectionsByBhikkhu = ['Select One'];
  Map<String, String> collectionNameId = {};
  String selectedCollection = 'Select One';

  List<String> allCategories = ['Select One'];
  String selectedCategory = 'Select One';

  List<String> allDownloadOptions = ['Select One', 'Free', 'Paid'];
  String selectedDownloadOption = 'Select One';

  List<String> predefinedHashtags = [
    '#Abhidharma',
    '#Sutra',
    '#Vienna',
    '#Meditation',
    '#Vipassana',
  ];
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
    trackNameController.dispose();
    bhikkhuIdController.dispose();
    collectionIdController.dispose();
    aliasController.dispose();
    titleController.dispose();
    bhikkhuNameENGController.dispose();
    audioTypeController.dispose();
    creditToController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(dhammaViewModelProvider.select((val) => val?.isLoading == true));

    ref.watch(getAllBhikkhusProvider).whenData((bhikkhus) {
      debugPrint(bhikkhus.toString());

      for (final bhikkhu in bhikkhus) {
        final bhikkhuName = bhikkhu.nameMM;
        if (!allBhikkhus.contains(bhikkhuName)) {
          allBhikkhus.add(bhikkhuName);
          bhikkhuNameId[bhikkhuName] = bhikkhu.id;
          bhikkhuNameENG[bhikkhuName] = bhikkhu.nameENG;
        }
      }
      debugPrint("Total bhikkhus: ${allBhikkhus.length}");
    });

    String? selectedBhikkhuId = bhikkhuNameId[selectedBhikkhu];
    if (selectedBhikkhuId != null && selectedBhikkhu != 'Select One') {
      ref
          .watch(getCollectionsByBhikkhuProvider(selectedBhikkhuId))
          .whenData((collections) {
        debugPrint('collections:---------------${collections.toList()}');
        for (final collection in collections) {
          if (!allCollectionsByBhikkhu.contains(collection.collectionName)) {
            allCollectionsByBhikkhu.add(collection.collectionName);
            collectionNameId[collection.collectionName] = collection.id;
          }
        }
        setState(() {});
      });

      ref.watch(getBhikkhuByIdProvider(selectedBhikkhuId)).whenData((bhikkhu) {
        aliasController.text = bhikkhu.alias;
        titleController.text = bhikkhu.title;
        bhikkhuProfileImageUrl = bhikkhu.profileImageUrl;

        setState(() {});
      });
    }

    ref.watch(getAllDhammaCategoriesProvider).whenData((categories) {
      debugPrint(categories.toString());

      for (final category in categories) {
        final categoryName = category.name;
        if (!allCategories.contains(categoryName)) {
          allCategories.add(categoryName);
        }
      }
      debugPrint("Total categories: ${allCategories.length}");
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(tUploadDhammaTrack),
        actions: [
          IconButton(
            onPressed: () async {
              if (formKey.currentState!.validate() && selectedImage != null) {
                ref.read(dhammaViewModelProvider.notifier).uploadDhammaTrack(
                      selectedAudio: selectedAudio!,
                      selectedThumbnail: selectedImage!,
                      dhammaName: trackNameController.text,
                      audioType: audioTypeController.text,
                      category: selectedCategory,
                      bhikkhuId: selectedBhikkhuId!,
                      bhikkhu: bhikkhuNameENGController.text,
                      bhikkhuMM: selectedBhikkhu,
                      bhikkhuAlias: aliasController.text,
                      bhikkhuTitle: titleController.text,
                      collectionId: collectionIdController.text,
                      collectionName: selectedCollection,
                      downloadOption: selectedDownloadOption,
                      creditTo: creditToController.text,
                      releaseDate: selectedDate!,
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
                        tDhamma,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // ------ Audio -----
                      selectedAudio == null
                          ? CustomfieldWidget(
                              hintText: tPickDhammaTrack,
                              controller: null,
                              readOnly: true,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return tAudioMissing;
                                }
                                return null;
                              },
                              onTap: selectAudio,
                            )
                          : AudioWave(path: selectedAudio!.path),

                      const SizedBox(height: 20),
                      // --- Dhamma Track ---
                      CustomfieldWidget(
                        hintText: tTrackName,
                        controller: trackNameController,
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
                        hintText: tDhamma,
                        controller: audioTypeController,
                        readOnly: true,
                      ),
                      const SizedBox(height: 10),
                      // ------ Category -----
                      const Text(
                        tCategory,
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
                              items: allCategories
                                  .map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem),
                                );
                              }).toList(),
                              onChanged: (value) {
                                selectedCategory = value!;
                              },
                              value: selectedCategory,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'AddCategoryScreen');
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
                      // ------ Bhikkhu -----
                      const Text(
                        tBhikkhuEng,
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
                                  return tSelectBhikkhu;
                                } else {
                                  return null;
                                }
                              },
                              isExpanded: true,
                              items:
                                  allBhikkhus.map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem),
                                );
                              }).toList(),
                              onChanged: (value) {
                                _onSelected(value!);
                              },
                              value: selectedBhikkhu,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'AddBhikkhuScreen');
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
                        hintText: tBhikkhuId,
                        controller: bhikkhuIdController,
                        readOnly: true,
                      ),
                      const SizedBox(height: 20),
                      CustomfieldWidget(
                        hintText: tBhikkhuEng,
                        controller: bhikkhuNameENGController,
                        readOnly: true,
                      ),
                      const SizedBox(height: 20),
                      CustomfieldWidget(
                        hintText: tAlias,
                        controller: aliasController,
                        readOnly: true,
                      ),
                      const SizedBox(height: 20),
                      CustomfieldWidget(
                        hintText: tTitle,
                        controller: titleController,
                        readOnly: true,
                      ),
                      const SizedBox(height: 10),
                      // ------ Album -----
                      const Text(
                        tCollection,
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
                              items: allCollectionsByBhikkhu
                                  .map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem),
                                );
                              }).toList(),
                              onChanged: (value) {
                                _onCollectionSelected(value!);
                              },
                              value: selectedCollection,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddCollection(
                                    bhikkhuProfileUrl: bhikkhuProfileImageUrl!,
                                    bhikkhuNameENG:
                                        bhikkhuNameENGController.text,
                                    bhikkhuNameMM: selectedBhikkhu,
                                    bhikkhuAlias: aliasController.text,
                                    bhikkhuTitle: titleController.text,
                                    bhikkhuId: selectedBhikkhuId!,
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
                        hintText: tCollection,
                        controller: collectionIdController,
                        readOnly: true,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        tReleaseDate,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
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
                      const SizedBox(height: 10),
                      // ------ Date -----
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
      selectedBhikkhu = value;
      bhikkhuIdController.text = bhikkhuNameId[value]!;
      bhikkhuNameENGController.text = bhikkhuNameENG[value]!;
      allCollectionsByBhikkhu = ['Select One'];
      selectedCollection = 'Select One';

      debugPrint('artist id:---------------${bhikkhuIdController.text}');
    });

    final bhikkhuId = bhikkhuNameId[selectedBhikkhu]!.toString();
    debugPrint('bhikkhuId:---------------$bhikkhuId');
  }

  void _onCollectionSelected(String value) {
    setState(() {
      selectedCollection = value;
      collectionIdController.text = collectionNameId[value]!;
    });
  }
}
