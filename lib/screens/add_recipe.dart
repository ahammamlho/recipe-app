import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe/dto/recipce_dto.dart';
import 'package:recipe/screens/profile_screen.dart';
import 'package:recipe/services/recipe_service.dart';
import 'package:recipe/services/upload_image_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final uploadImageService = UploadImageService();
  final recipceService = RecipceService();

  List<String> ingredients = [""];
  List<String> preparations = [""];
  List<String> tags = [];
  TextEditingController tagController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  File? _imageFile;

  double selectedMinutes = 15.0;
  double _selectedMinutes = 15.0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Recipe"),
        backgroundColor: Colors.blueAccent,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.abc))],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildUploadPictureSection(context, width),
              const SizedBox(height: 20),
              _buildTitleField(),
              const SizedBox(height: 10),
              _buildPreparationTime(),
              const SizedBox(height: 20),
              const Divider(color: Colors.black, thickness: 0.5),
              const SizedBox(height: 20),
              _buildSectionTitle("Add Ingredients"),
              _buildDynamicList(
                ingredients,
                "Ingredient",
                "ex: 1 Cup water",
                width,
                (index) => ingredients.removeAt(index),
                () => ingredients.add(""),
              ),
              const Divider(color: Colors.black, thickness: 0.5),
              const SizedBox(height: 20),
              _buildSectionTitle("Preparation"),
              _buildDynamicList(
                preparations,
                "Step",
                "ex: In a large bowl ...",
                width,
                (index) => preparations.removeAt(index),
                () => preparations.add(""),
              ),
              _buildSectionTitle("Tags"),
              const SizedBox(height: 20),
              _buildTagsList(width),
              _buildActionButtons(width),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadPictureSection(BuildContext context, double width) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: width * 0.4,
      width: width * 0.9,
      decoration: BoxDecoration(
        border: Border.all(width: 0.4),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: GestureDetector(
        onTap: () {
          _showUploadPicDialog(context, width);
        },
        child: _imageFile == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt_outlined, size: 30),
                  SizedBox(height: 2),
                  Text("Upload Recipe Picture", style: TextStyle(fontSize: 18)),
                ],
              )
            : ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.file(
                  _imageFile!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: titleController,
      decoration: InputDecoration(
        labelText: "Title",
        hintText: "Choose Title of your recipe",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
      ),
    );
  }

  Widget _buildPreparationTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preparation Time',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Slider(
          min: 15.0,
          max: 240.0,
          divisions: 15,
          value: _selectedMinutes,
          label: _formatTime(_selectedMinutes),
          onChanged: (value) {
            setState(() {
              _selectedMinutes = value;
            });
          },
          activeColor: Colors.blue,
          inactiveColor: Colors.grey[300],
        ),
      ],
    );
  }

  String _formatTime(double minutes) {
    int hours = minutes ~/ 60;
    int mins = (minutes % 60).toInt();
    if (hours > 0) {
      if (mins == 0) {
        return '${hours}h';
      } else {
        return '${hours}h ${mins}m';
      }
    } else {
      return '${mins}m';
    }
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDynamicList(
    List<String> items,
    String labelPrefix,
    String hintText,
    double width,
    Function(int index) onDelete,
    Function onAdd,
  ) {
    return Column(
      children: [
        Column(
          children: items.asMap().entries.map((entry) {
            int index = entry.key;
            String value = entry.value;

            return Container(
              margin: const EdgeInsets.only(top: 10),
              child: TextField(
                controller: TextEditingController(text: value),
                onChanged: (newValue) {
                  items[index] = newValue;
                },
                maxLines: labelPrefix == "Step" ? null : 1,
                decoration: InputDecoration(
                  labelText: "$labelPrefix ${index + 1}",
                  hintText: hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: items.length == 1 ? Colors.grey : Colors.red,
                    ),
                    onPressed: items.length == 1
                        ? null
                        : () {
                            setState(() {
                              onDelete(index);
                            });
                          },
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  onAdd();
                });
              },
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                height: 30,
                width: 80,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 5),
                    Text("Add"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTagsList(
    double width,
  ) {
    return Column(
      children: [
        tags != null
            ? Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                runAlignment: WrapAlignment.start,
                alignment: WrapAlignment.start,
                spacing: 8.0,
                runSpacing: 8.0,
                children: tags.asMap().entries.map((entry) {
                  int index = entry.key;
                  String value = entry.value;
                  return Container(
                    height: 35,
                    padding: const EdgeInsets.only(left: 15, right: 0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                      color: Colors.blue,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          value,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                tags.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.cancel,
                                size: 16, color: Colors.red))
                      ],
                    ),
                  );
                }).toList(),
              )
            : Container(),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: TextField(
            controller: tagController,
            onChanged: (newValue) {},
            maxLines: 1,
            decoration: InputDecoration(
              labelText: "tag ${tags.length + 1}",
              hintText: "Ex #recipce",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (tagController.text.trim() != "") {
                    tags.add(tagController.text.trim());
                    tagController = TextEditingController(text: "");
                  }
                });
              },
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                height: 30,
                width: 80,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 5),
                    Text("Add"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton("Publish", Colors.green, width * 0.3),
        _buildActionButton("Save as draft", Colors.orange, width * 0.3),
      ],
    );
  }

  Widget _buildActionButton(String text, Color color, double width) {
    return GestureDetector(
      onTap: () async {
        String? validationMessage = _validateRecipeInputs();
        if (validationMessage != null) {
          _showURequiredItemDialog(context, validationMessage);
          return;
        }

        try {
          final recipeUrl = await uploadImageService.uploadImageRecipe(
            "recipes",
            _imageFile!,
          );
          if (recipeUrl == null) {
            _showURequiredItemDialog(context, "Failed to upload recipe image.");
            return;
          }
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final String uuidUser = prefs.getString('uuid_user') ?? "";
          final recipeData = RecipceDto(
            uuid: "",
            uuidUser: uuidUser,
            titleRecipe: titleController.text.trim(),
            ingredients: trimList(ingredients),
            steps: trimList(preparations),
            recipeUrl: recipeUrl,
            timer: _selectedMinutes,
            numberLikes: 0,
            tags: trimList(tags),
          );

          await recipceService.addRecipe(recipeData);
          _showSuccessDialog(context, "Recipe added successfully!");
        } catch (error) {
          _showURequiredItemDialog(
              context, "Failed to add recipe. Please try again.");
        }
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        height: 40,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  String? _validateRecipeInputs() {
    if (_imageFile == null) {
      return "Please upload a recipe picture.";
    } else if (titleController.text.trim().isEmpty) {
      return "Please provide a title.";
    } else if (trimList(ingredients).isEmpty) {
      return "Please add at least one ingredient.";
    } else if (trimList(preparations).isEmpty) {
      return "Please add at least one step.";
    } else if (trimList(tags).isEmpty) {
      return "Please add at least one tag.";
    }
    return null;
  }

  void _showSuccessDialog(BuildContext context, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      dismissOnTouchOutside: false,
      desc: message,
      descTextStyle: const TextStyle(fontSize: 18),
      btnCancelText: "Add new recipe",
      btnOkText: "Profile",
      btnCancelOnPress: () {
        cleanData();
      },
      btnOkOnPress: () {
        cleanData();
        Get.to(() => const ProfileScreen());
      },
    ).show();
  }

  void cleanData() {
    setState(() {
      _imageFile = null;
      titleController = TextEditingController(text: "");
      tagController = TextEditingController(text: "");
      ingredients = [""];
      preparations = [""];
      tags = [];
      _selectedMinutes = 15.0;
    });
  }

  List<String> trimList(List<String> strings) {
    List<String> cleanedList =
        strings.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    return cleanedList;
  }

  void _showUploadPicDialog(BuildContext context, double width) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.rightSlide,
      title: 'Dialog Title',
      desc: 'Upload recipe picture',
      // btnCancelOnPress: () {},
      // btnOkOnPress: () {},
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Upload recipe picture',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              getPhoto(true);
            },
            child: Container(
                width: width * 0.5,
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: const Center(
                  child: Text("Take a photo",
                      style: TextStyle(color: Colors.black)),
                )),
          ),
          const Divider(color: Colors.black, thickness: 0.2),
          GestureDetector(
            onTap: () {
              getPhoto(false);
            },
            child: Container(
                width: width * 0.5,
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: const Center(
                  child: Text("Choose a photo",
                      style: TextStyle(color: Colors.black)),
                )),
          ),
        ],
      ),
    ).show();
  }

  void _showURequiredItemDialog(BuildContext context, String text) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.rightSlide,
      dismissOnTouchOutside: false,
      desc: text,
      descTextStyle: const TextStyle(fontSize: 18),
      btnCancelOnPress: () {},
      // btnOkOnPress: () {},
    ).show();
  }

  Future<void> getPhoto(bool isFromCamera) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
          source: isFromCamera ? ImageSource.camera : ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        Get.back();
      }
    } catch (e) {
      print("Error capturing photo: $e");
    }
  }
}
