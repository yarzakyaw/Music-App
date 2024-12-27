import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mingalar_music_app/core/constants/text_strings.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/utils.dart';
import 'package:mingalar_music_app/core/widgets/customfield_widget.dart';
import 'package:mingalar_music_app/core/widgets/loader.dart';
import 'package:mingalar_music_app/features/home/viewmodel/home_view_model.dart';

class AddAlbum extends ConsumerStatefulWidget {
  final String artistNameENG;
  final String artistNameMM;
  final String artistId;

  const AddAlbum({
    super.key,
    required this.artistId,
    required this.artistNameENG,
    required this.artistNameMM,
  });

  @override
  ConsumerState<AddAlbum> createState() => _AddAlbumState();
}

class _AddAlbumState extends ConsumerState<AddAlbum> {
  final albumController = TextEditingController();
  final artistNameENGController = TextEditingController();
  final artistNameMMController = TextEditingController();
  final artistIdController = TextEditingController();
  File? selectedImage;
  final formKey = GlobalKey<FormState>();

  String artistProfileUrl = '';

  DateTime? selectedDate;

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

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    albumController.dispose();
    artistNameENGController.dispose();
    artistNameMMController.dispose();
    artistIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(homeViewModelProvider.select((val) => val?.isLoading == true));

    ref.watch(getArtistProfileProvider(widget.artistId)).whenData((profile) {
      artistProfileUrl = profile;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(tAddAlbum),
        actions: [
          IconButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                ref.read(homeViewModelProvider.notifier).addAlbum(
                      selectedAlbumImage: selectedImage!,
                      albumName: albumController.text,
                      artistId: widget.artistId,
                      releaseDate: selectedDate!,
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
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      /// -- IMAGE with ICON
                      Center(
                        child: artistProfileUrl == ''
                            ? Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppPallete.greyColor, width: 2),
                                ),
                                child: const CircleAvatar(
                                  maxRadius: 60,
                                  backgroundColor: AppPallete.transparentColor,
                                  child: ClipOval(
                                    child: Icon(
                                      LineAwesomeIcons.user,
                                      size: 100,
                                      color: AppPallete.greyColor,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppPallete.greyColor, width: 2),
                                ),
                                child: CircleAvatar(
                                  maxRadius: 70,
                                  backgroundColor: AppPallete.transparentColor,
                                  backgroundImage: NetworkImage(
                                    artistProfileUrl,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 10),
                      // --- Artist Name Eng ---
                      CustomfieldWidget(
                        hintText: widget.artistNameENG,
                        controller: artistNameENGController,
                        readOnly: true,
                      ),
                      const SizedBox(height: 10),
                      // --- Artist Name MM ---
                      CustomfieldWidget(
                        hintText: widget.artistNameMM,
                        controller: artistNameMMController,
                        readOnly: true,
                      ),
                      const SizedBox(height: 10),
                      // --- Artist Id ---
                      CustomfieldWidget(
                        hintText: widget.artistId,
                        controller: artistIdController,
                        readOnly: true,
                      ),
                      const SizedBox(height: 10),
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
                                    fit: BoxFit.scaleDown,
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
                      const SizedBox(height: 10),
                      CustomfieldWidget(
                        hintText: tAlbumName,
                        controller: albumController,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return tAlbumNameMissing;
                          }
                          return null;
                        },
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
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
