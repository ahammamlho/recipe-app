import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe/const/app_styles.dart';
import 'package:recipe/data/user_service.dart';
import 'package:recipe/dto/user_dto.dart';
import 'package:recipe/screens/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final userService = UserService();

  late UserDTO userData;
  bool loading = true;

  @override
  void initState() {
    super.didChangeDependencies();
    getDataUser();
  }

  Future<void> getDataUser() async {
    try {
      UserDTO? data = await userService.getCurrentUserData();
      if (data == null) {
        setState(() {
          loading = false;
        });
        return;
      }
      setState(() {
        userData = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      print("Error fetching user data: $e");
      // Optionally show a SnackBar or an AlertDialog
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        elevation: 1,
      ),
      body: !loading
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildProfileHeader(),
                    const SizedBox(height: 20),
                    _buildBioSection(),
                    const SizedBox(height: 20),
                    _buildStatsSection(),
                    const SizedBox(height: 20),
                    _buildActionButtons(width),
                  ],
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        _buildProfilePicture(),
        const SizedBox(width: 10),
        _buildProfileInfo(),
      ],
    );
  }

  Widget _buildProfilePicture() {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(100),
        ),
        color: Colors.white,
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
          imageUrl: userData.avatarUrl,
          width: 75,
          height: 75,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, progress) => const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          errorWidget: (context, url, error) =>
              const Icon(Icons.error, size: 40),
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          userData.userName,
          style: AppTextStyles.heading2,
        ),
        Text(
          userData.status,
          style: AppTextStyles.body,
        ),
        userData.socialMediaUrl != ""
            ? Text(
                userData.socialMediaUrl,
                style: const TextStyle(
                  color: Colors.blue,
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  Widget _buildBioSection() {
    return userData.bio != ""
        ? Row(
            children: [
              Text(
                userData.bio,
                style: AppTextStyles.body,
                textAlign: TextAlign.start,
              ),
            ],
          )
        : Container();
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(userData.numberRecipes, "Recipes"),
          _buildStatItem(userData.viewsProfile, "Views"),
          _buildStatItem(userData.numberFollowers, "Followers"),
        ],
      ),
    );
  }

  Widget _buildStatItem(int value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "$value",
          style: AppTextStyles.heading2,
        ),
        Text(
          label,
          style: AppTextStyles.body,
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    double width,
  ) {
    return Row(
      children: [
        _buildActionButton(width * 0.5 - 20, "My Recipes", AppColors.button,
            Colors.white, () {}),
        _buildActionButton(
            width * 0.5 - 20, "Edit Profile", Colors.white, Colors.black,
            () async {
          final updatedUser =
              await Get.to(() => EditProfileScreen(user: userData));
          if (updatedUser != null) {
            setState(() {
              userData = updatedUser;
            });
          }
        }),
      ],
    );
  }

  Widget _buildActionButton(
    double width,
    String label,
    Color backgroundColor,
    Color textColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: label == "Edit Profile"
              ? const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
          color: backgroundColor,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}