import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mingalar_music_app/core/constants/text_strings.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/utils.dart';
import 'package:mingalar_music_app/core/widgets/customfield_widget.dart';
import 'package:mingalar_music_app/core/widgets/loader.dart';
import 'package:mingalar_music_app/features/home/viewmodel/home_view_model.dart';

class AddArtist extends ConsumerStatefulWidget {
  const AddArtist({
    super.key,
  });

  @override
  ConsumerState<AddArtist> createState() => _AddArtistState();
}

class _AddArtistState extends ConsumerState<AddArtist> {
  final artistNameController = TextEditingController();
  final artistNameMMController = TextEditingController();

  File? selectedImage;
  final formKey = GlobalKey<FormState>();

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
    artistNameController.dispose();
    artistNameMMController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(homeViewModelProvider.select((val) => val?.isLoading == true));

    return Scaffold(
      appBar: AppBar(
        title: const Text(tAddArtist),
        actions: [
          IconButton(
            onPressed: () async {
              if (formKey.currentState!.validate() && selectedImage != null) {
                ref.read(homeViewModelProvider.notifier).addArtist(
                    selectedProfileImage: selectedImage!,
                    nameENG: artistNameController.text,
                    nameMM: artistNameMMController.text);
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
                    children: [
                      /// -- IMAGE with ICON
                      Center(
                        child: Stack(
                          children: [
                            selectedImage == null
                                ? Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppPallete.greyColor,
                                          width: 2),
                                    ),
                                    child: const CircleAvatar(
                                      maxRadius: 60,
                                      backgroundColor:
                                          AppPallete.transparentColor,
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
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                        color: AppPallete.greyColor,
                                        width: 2,
                                      ),
                                    ),
                                    child: Image.file(
                                      selectedImage!,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: IconButton(
                                  onPressed: () => selectImage(),
                                  icon: const Icon(
                                    LineAwesomeIcons.image_solid,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // --- Artist Name Eng ---
                      CustomfieldWidget(
                        hintText: tArtistNameEng,
                        controller: artistNameController,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return tMissingFields;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // --- Artist Name Eng ---
                      CustomfieldWidget(
                        hintText: tArtistNameMM,
                        controller: artistNameMMController,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return tMissingFields;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
