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
import 'package:mingalar_music_app/features/dhamma/viewmodel/dhamma_view_model.dart';

class AddCollection extends ConsumerStatefulWidget {
  final String? bhikkhuProfileUrl;
  final String bhikkhuNameENG;
  final String bhikkhuNameMM;
  final String bhikkhuAlias;
  final String bhikkhuTitle;
  final String bhikkhuId;

  const AddCollection({
    super.key,
    this.bhikkhuProfileUrl,
    required this.bhikkhuNameENG,
    required this.bhikkhuNameMM,
    required this.bhikkhuAlias,
    required this.bhikkhuTitle,
    required this.bhikkhuId,
  });

  @override
  ConsumerState<AddCollection> createState() => _AddCollectionState();
}

class _AddCollectionState extends ConsumerState<AddCollection> {
  final collectionController = TextEditingController();
  final bhikkhuNameENGController = TextEditingController();
  final bhikkhuNameMMController = TextEditingController();
  final bhikkhuIdController = TextEditingController();
  final bhikkhuAliasController = TextEditingController();
  final bhikkhuTitleController = TextEditingController();

  File? selectedImage;
  final formKey = GlobalKey<FormState>();

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
    collectionController.dispose();
    bhikkhuNameENGController.dispose();
    bhikkhuNameMMController.dispose();
    bhikkhuIdController.dispose();
    bhikkhuAliasController.dispose();
    bhikkhuTitleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(dhammaViewModelProvider.select((val) => val?.isLoading == true));

    return Scaffold(
      appBar: AppBar(
        title: const Text(tAddCollection),
        actions: [
          IconButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                ref.read(dhammaViewModelProvider.notifier).addCollection(
                      selectedCollectionImage: selectedImage!,
                      collectionName: collectionController.text,
                      bhikkhuId: widget.bhikkhuId,
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
                        child: widget.bhikkhuProfileUrl == null
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
                                    widget.bhikkhuProfileUrl!,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 10),
                      // --- Artist Name MM ---
                      CustomfieldWidget(
                        hintText: widget.bhikkhuNameMM,
                        controller: bhikkhuNameMMController,
                        readOnly: true,
                      ),
                      const SizedBox(height: 10),
                      // --- Artist Name ENG ---
                      CustomfieldWidget(
                        hintText: widget.bhikkhuNameENG,
                        controller: bhikkhuNameENGController,
                        readOnly: true,
                      ),
                      const SizedBox(height: 10),
                      // --- Artist Alias ---
                      CustomfieldWidget(
                        hintText: widget.bhikkhuAlias,
                        controller: bhikkhuAliasController,
                        readOnly: true,
                      ),
                      const SizedBox(height: 10),
                      // --- Artist Title ---
                      CustomfieldWidget(
                        hintText: widget.bhikkhuTitle,
                        controller: bhikkhuTitleController,
                        readOnly: true,
                      ),
                      const SizedBox(height: 10),
                      // --- Artist Id ---
                      CustomfieldWidget(
                        hintText: widget.bhikkhuId,
                        controller: bhikkhuIdController,
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
                        hintText: tCollectionName,
                        controller: collectionController,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return tCollectionNameMissing;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // ------ Date -----
                      Container(
                        height: 70,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 15,
                        ),
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
