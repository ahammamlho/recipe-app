import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe/const/app_styles.dart';
import 'package:recipe/screens/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        elevation: 1,
      ),
      body: SingleChildScrollView(
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
      ),
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
          imageUrl:
              "https://media.istockphoto.com/id/1352937979/photo/vegetable-storage.jpg?s=2048x2048&w=is&k=20&c=0nk02sPEhDEYwOWLHpELRCmTpbKBCYmQqwEIuLDfTS0=",
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
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "_diamoris",
          style: AppTextStyles.heading2,
        ),
        Text(
          "new member",
          style: AppTextStyles.body,
        ),
        Text(
          "instagram.com/_diamoris/",
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildBioSection() {
    return const Text(
      "A passionate recipe developer blending traditional techniques with modern flavors.",
      style: AppTextStyles.body,
      textAlign: TextAlign.center,
    );
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
          _buildStatItem("353", "Recipes"),
          _buildStatItem("124", "Views"),
          _buildStatItem("1.5K", "Followers"),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: AppTextStyles.heading2,
        ),
        Text(
          label,
          style: AppTextStyles.body,
        ),
      ],
    );
  }

  Widget _buildActionButtons(double width) {
    return Row(
      children: [
        _buildActionButton(
          width * 0.5 - 20,
          "My Recipes",
          AppColors.button,
          Colors.white,
        ),
        _buildActionButton(
          width * 0.5 - 20,
          "Edit Profile",
          Colors.white,
          Colors.black,
        ),
      ],
    );
  }

  Widget _buildActionButton(
      double width, String label, Color backgroundColor, Color textColor) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const EditProfileScreen());
      },
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
