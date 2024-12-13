import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe/const/app_styles.dart';
import 'package:recipe/data/user_service.dart';
import 'package:recipe/dto/user_dto.dart';

class EditProfileScreen extends StatefulWidget {
  final UserDTO user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final userService = UserService();

  TextEditingController _userNameController = TextEditingController();
  TextEditingController _linkontroller = TextEditingController();
  TextEditingController _bioController = TextEditingController();

  late UserDTO updateDataUser;

  bool isUserNameValid = true;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController(text: widget.user.userName);
    _linkontroller = TextEditingController(text: widget.user.socialMediaUrl);
    _bioController = TextEditingController(text: widget.user.bio);

    setState(() {
      updateDataUser = widget.user;
    });
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
            Get.back(result: updateDataUser);
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  isUserNameValid = isValidUserName(_userNameController.text);
                });
                if (isUserNameValid) {
                  updateDataUser = UserDTO.fromJson({
                    ...(updateDataUser.toJson()),
                    "user_name": _userNameController.text,
                    "bio": _bioController.text,
                    "social_media_link": _linkontroller.text,
                  });
                  await userService.updateUserData(updateDataUser);
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
              _buildProfilePicture(),
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

  Widget _buildProfilePicture() {
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
                child: CachedNetworkImage(
                  imageUrl:
                      "https://media.istockphoto.com/id/1352937979/photo/vegetable-storage.jpg?s=2048x2048&w=is&k=20&c=0nk02sPEhDEYwOWLHpELRCmTpbKBCYmQqwEIuLDfTS0=",
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, progress) =>
                      const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, size: 40),
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
                  onPressed: () {},
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
                label == "Username" ? _userNameController : _linkontroller,
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
}
