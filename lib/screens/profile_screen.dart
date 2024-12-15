import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:get/get.dart';
import 'package:recipe/const/app_styles.dart';
import 'package:recipe/dto/recipce_dto.dart';
import 'package:recipe/screens/recipe_preview.dart';
import 'package:recipe/services/liked_recipe_service.dart';
import 'package:recipe/services/recipe_service.dart';
import 'package:recipe/services/user_service.dart';
import 'package:recipe/dto/user_dto.dart';
import 'package:recipe/screens/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final userService = UserService();
  final recipceService = RecipceService();
  final likedRecipeService = LikedRecipeService();

  late UserDTO userData;
  List<RecipceDto> recipces = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  Future<void> getDataUser() async {
    try {
      UserDTO? data = await userService.getCurrentUserData();
      List<RecipceDto>? recipcesTmp = await recipceService.getMyRecipe();

      if (data == null) {
        setState(() {
          loading = false;
        });
        return;
      }
      setState(() {
        userData = data;
        if (recipcesTmp != null) recipces = recipcesTmp;
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
                    const SizedBox(height: 20),
                    recipces.isNotEmpty
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1.4,
                            ),
                            itemCount: recipces.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _buildContent(context, recipces[index]);
                            },
                          )
                        : Container(),
                  ],
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildContent(BuildContext context, RecipceDto recipce) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(context, recipce),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              recipce.titleRecipe,
              style: AppTextStyles.heading2,
            ),
          ),
          _buildFooter(recipce),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context, RecipceDto recipe) {
    return GestureDetector(
      onTap: () async {
        final updatedRecipe = await Get.to(() => RecipePreview(recipe: recipe));
        if (updatedRecipe != null) {
          setState(() {
            recipe = updatedRecipe;
          });
        }
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        child: CachedNetworkImage(
          imageUrl: recipe.recipeUrl,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, progress) =>
              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }

  Widget _buildFooter(RecipceDto recipce) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              final likedTmp =
                  await likedRecipeService.toggleLikedRecipe(recipce.uuid);
              setState(() {
                recipce.isLikedByOwner = likedTmp;
                if (likedTmp) {
                  recipce.numberLikes++;
                } else {
                  recipce.numberLikes--;
                }
              });
            },
            child: Icon(Icons.favorite,
                color: recipce.isLikedByOwner ? Colors.red : Colors.grey[300],
                size: AppSizes.iconSize),
          ),
          const SizedBox(width: 5),
          Text("${recipce.numberLikes}", style: AppTextStyles.body),
          const SizedBox(width: 10),
          RatingStars(
            value: recipce.rateReviews,
            onValueChanged: (v) {},
            starCount: 5,
            starSize: 18,
            starSpacing: 2,
            maxValue: 5,
            valueLabelVisibility: false,
            starOffColor: const Color(0xffe7e8ea),
            starColor: Colors.yellow,
          ),
          const SizedBox(width: 5),
          Text("${recipce.numberReviews} Reviews", style: AppTextStyles.body),
          const Spacer(),
          const Icon(Icons.timer_outlined,
              color: Colors.green, size: AppSizes.iconSize),
          const SizedBox(width: 5),
          Text(_formatTime(recipce.timer), style: AppTextStyles.body),
        ],
      ),
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
