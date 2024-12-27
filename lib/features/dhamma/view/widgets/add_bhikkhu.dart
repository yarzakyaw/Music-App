import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mingalar_music_app/core/constants/text_strings.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/utils.dart';
import 'package:mingalar_music_app/core/widgets/customfield_widget.dart';
import 'package:mingalar_music_app/core/widgets/loader.dart';
import 'package:mingalar_music_app/features/dhamma/viewmodel/dhamma_view_model.dart';

class AddBhikkhu extends ConsumerStatefulWidget {
  const AddBhikkhu({super.key});

  @override
  ConsumerState<AddBhikkhu> createState() => _AddBhikkhuState();
}

class _AddBhikkhuState extends ConsumerState<AddBhikkhu> {
  final bhikkhuNameController = TextEditingController();
  final bhikkhuNameMMController = TextEditingController();
  final bhikkhuAliasController = TextEditingController();
  final bhikkhuTitleController = TextEditingController();

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
    bhikkhuNameController.dispose();
    bhikkhuNameMMController.dispose();
    bhikkhuAliasController.dispose();
    bhikkhuTitleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(dhammaViewModelProvider.select((val) => val?.isLoading == true));

    return Scaffold(
      appBar: AppBar(
        title: const Text(tAddBhikkhu),
        actions: [
          IconButton(
            onPressed: () async {
              if (formKey.currentState!.validate() && selectedImage != null) {
                ref.read(dhammaViewModelProvider.notifier).addBhikkhu(
                      selectedProfileImage: selectedImage!,
                      nameENG: bhikkhuNameController.text,
                      nameMM: bhikkhuNameMMController.text,
                      alias: bhikkhuAliasController.text,
                      title: bhikkhuTitleController.text,
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
                                        width: 2,
                                      ),
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
                      // --- Bhikkhu Name Myanmar ---
                      CustomfieldWidget(
                        hintText: tBhikkhuNameMM,
                        controller: bhikkhuNameMMController,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return tMissingFields;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // --- Bhikkhu Name Eng ---
                      CustomfieldWidget(
                        hintText: tBhikkhuNameEng,
                        controller: bhikkhuNameController,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return tMissingFields;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // --- Bhikkhu Name Alias ---
                      CustomfieldWidget(
                        hintText: tBhikkhuAlias,
                        controller: bhikkhuAliasController,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return tMissingFields;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // --- Artist Name Alias ---
                      CustomfieldWidget(
                        hintText: tBhikkhuTitle,
                        controller: bhikkhuTitleController,
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
