import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe/const/app_styles.dart';
import 'package:recipe/services/upload_image_service.dart';
import 'package:recipe/services/user_service.dart';
import 'package:recipe/dto/user_dto.dart';

class EditProfileScreen extends StatefulWidget {
  final UserDTO user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final userService = UserService();
  final uploadImageService = UploadImageService();

  TextEditingController _userNameController = TextEditingController();
  TextEditingController _linkController = TextEditingController();
  TextEditingController _bioController = TextEditingController();

  late UserDTO updateDataUser;

  bool isUserNameValid = true;
  bool isMadeChange = false;

  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController(text: widget.user.userName);
    _linkController = TextEditingController(text: widget.user.socialMediaUrl);
    _bioController = TextEditingController(text: widget.user.bio);

    updateDataUser = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (isMadeChange) {
              _showMadeChnageDialog(context);
            } else {
              Get.back(result: updateDataUser);
            }
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () async {
                String? urlImage;

                setState(() {
                  isUserNameValid = isValidUserName(_userNameController.text);
                });
                if (isUserNameValid) {
                  if (_imageFile != null) {
                    urlImage = await uploadImageService.uploadAvatar(
                        "avatars", _imageFile!, updateDataUser.uuid);
                  }
                  updateDataUser = UserDTO.fromJson({
                    ...(updateDataUser.toJson()),
                    "user_name": _userNameController.text,
                    "bio": _bioController.text,
                    "social_media_link": _linkController.text,
                    "avatar_url": _imageFile != null && urlImage != null
                        ? "$urlImage?time${DateTime.now().millisecondsSinceEpoch}"
                        : updateDataUser.avatarUrl,
                  });
                  await userService.updateUserData(updateDataUser);

                  setState(() {
                    isMadeChange = false;
                  });
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildProfilePicture(width),
              const SizedBox(height: 30),
              _buildTextField("Username", "Enter your username", width),
              const SizedBox(height: 20),
              _buildTextField("Link", "Link to social media", width),
              const SizedBox(height: 20),
              _buildBioSection(width),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture(double width) {
    return Center(
      child: SizedBox(
        width: 90,
        height: 90,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColors.inputColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 2),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: _imageFile == null
                    ? CachedNetworkImage(
                        imageUrl: updateDataUser.avatarUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, url, progress) =>
                            const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (context, url, error) {
                          return const Icon(Icons.error, size: 40);
                        },
                      )
                    : Image.file(
                        _imageFile!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: AppColors.background),
                  borderRadius: BorderRadius.circular(100),
                  color: AppColors.inputColor,
                ),
                child: IconButton(
                  onPressed: () async {
                    _showAvatarDialog(context, width);
                  },
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.heading2,
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: width - 40,
          child: TextField(
            controller:
                label == "Username" ? _userNameController : _linkController,
            onChanged: (_) {
              setState(() {
                isMadeChange = true;
              });
            },
            decoration: InputDecoration(
              hintText: hint,
              errorText: label == "Username" && !isUserNameValid
                  ? "Use 1-12 characters (letters, numbers, _ or -)"
                  : null,
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isUserNameValid ? Colors.grey : Colors.red,
                  width: 2,
                ),
              ),
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
      ],
    );
  }

  Widget _buildBioSection(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bio',
          style: AppTextStyles.heading,
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: width - 40,
          child: TextField(
            controller: _bioController,
            onChanged: (_) {
              setState(() {
                isMadeChange = true;
              });
            },
            maxLines: 4,
            maxLength: 200,
            decoration: InputDecoration(
              hintText: "Write a short bio about yourself",
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
        const SizedBox(height: 8),
        const Text(
          "Add a short bio to tell the Community more about yourself. What's your favorite dish? Why do you love to cook?",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  bool isValidUserName(String userName) {
    final RegExp validPattern = RegExp(r'^[a-zA-Z0-9_-]{5,12}$');
    return validPattern.hasMatch(userName);
  }

  void _showAvatarDialog(BuildContext context, double width) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismiss by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Rounded corners
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Choose avatar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(12.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: 6,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () async {
                        File file = await getFileFromAssets(
                            "assets/avatar/avatar_${index + 1}.png");
                        setState(() {
                          isMadeChange = true;
                          _imageFile = file;
                        });
                        Get.back();
                      },
                      child: Image.asset(
                        "assets/avatar/avatar_${index + 1}.png",
                        width: 40,
                        height: 40,
                      ),
                    );
                  },
                ),
                const Divider(color: Colors.black, thickness: 0.2),
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
          ),
        );
      },
    );
  }

  Future<void> getPhoto(bool isFromCamera) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
          source: isFromCamera ? ImageSource.camera : ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          isMadeChange = true;
        });
        Get.back();
      }
    } catch (e) {
      print("Error capturing photo: $e");
    }
  }

  Future<File> getFileFromAssets(String assetPath) async {
    try {
      final byteData = await rootBundle.load(assetPath);
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/${assetPath.split('/').last}');

      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      return file;
    } catch (e) {
      throw Exception("Error while getting file from assets: $e");
    }
  }

  void _showMadeChnageDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Are you sure you want to discard your changes?',
                  style: TextStyle(
                    fontSize: 16,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          child: const Center(
                            child: Text("Cancel",
                                style: TextStyle(color: Colors.orange)),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                        Get.back(result: updateDataUser);
                      },
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          child: const Center(
                            child: Text("Discard",
                                style: TextStyle(color: Colors.orange)),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
