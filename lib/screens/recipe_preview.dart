import 'dart:io';
import 'package:timeago/timeago.dart' as timeago;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe/const/app_styles.dart';
import 'package:recipe/dto/recipce_dto.dart';
import 'package:recipe/dto/review_dto.dart';
import 'package:recipe/services/liked_recipe_service.dart';
import 'package:recipe/services/review_service.dart';
import 'package:recipe/services/upload_image_service.dart';
import 'package:recipe/widgets/expandable_text.dart';
import 'package:recipe/widgets/time_line_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipePreview extends StatefulWidget {
  final RecipceDto recipe;
  const RecipePreview({super.key, required this.recipe});

  @override
  State<RecipePreview> createState() => _RecipePreviewState();
}

class _RecipePreviewState extends State<RecipePreview> {
  final likedRecipeService = LikedRecipeService();
  final uploadImageService = UploadImageService();
  final reviewService = ReviewService();

  ReviewDto review = ReviewDto(
      uuid: "",
      uuidUser: "",
      uuidRecipe: "",
      rate: 5,
      feedback: '',
      imgUrl: '',
      userAvatar: '',
      userName: '',
      createdAt: DateTime.now());
  File? _imageFile;
  List<ReviewDto>? reviews;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final res = await reviewService.getReviewByRecipe(widget.recipe.uuid);
    print(res?[0].userName);
    setState(() {
      reviews = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipe Details"),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back(result: widget.recipe);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(width),
            _buildSectionTitle("Ingredients"),
            _buildIngredientsList(),
            _buildSectionTitle("Steps"),
            TimeLineWidget(
              steps: widget.recipe.steps,
              isCheckedList:
                  List.generate(widget.recipe.steps.length, (index) => false),
            ),
            _buildSectionTitle("Tags"),
            _buildTagsSection(),
            const SizedBox(height: 10),
            const Divider(
              color: Colors.grey,
              thickness: 0.5,
              indent: 20,
              endIndent: 20,
            ),
            _buildSectionTitle("Reviews"),
            reviews != null ? _buildReviewsSection(width) : Container(),
            const Divider(
              color: Colors.grey,
              thickness: 0.5,
              indent: 20,
              endIndent: 20,
            ),
            _buildLeaveReview(width),
            Container(
              padding: const EdgeInsets.only(top: 20),
              child: const Divider(
                color: Colors.grey,
                thickness: 0.5,
                indent: 20,
                endIndent: 20,
              ),
            ),
            reviews != null
                ? Column(
                    children: reviews!.asMap().entries.map((entry) {
                      ReviewDto feedback = entry.value;
                      print(feedback.userName);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: _buildUserReviewSection(width, feedback),
                      );
                    }).toList(),
                  )
                : Container(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsSection() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        runAlignment: WrapAlignment.start,
        alignment: WrapAlignment.start,
        spacing: 8.0,
        runSpacing: 8.0,
        children: widget.recipe.tags.asMap().entries.map((entry) {
          // int index = entry.key;
          String value = entry.value;
          return Text(
            "#$value",
            style: const TextStyle(color: Colors.black, fontSize: 16),
          );
        }).toList(),
      ),
    );
  }

  List<double> calculateRatingSummary() {
    if (reviews == null) {
      return [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    }
    double totalRating = 0.0;
    int count = reviews!.length;

    for (var review in reviews!) {
      totalRating += review.rate;
    }
    double averageRating = totalRating / count;

    List<double> ratingDistribution = List.filled(5, 0.0);
    for (var review in reviews!) {
      if (review.rate >= 1 && review.rate <= 5) {
        ratingDistribution[review.rate.toInt() - 1] += 1;
      }
    }

    for (int i = 0; i < ratingDistribution.length; i++) {
      ratingDistribution[i] = (ratingDistribution[i] / count);
    }

    return [averageRating, ...ratingDistribution];
  }

  Widget _buildReviewsSection(double width) {
    List<double> summury = calculateRatingSummary();
    print(summury);
    return Center(
      child: Column(
        children: [
          Text(
            summury[0].toStringAsFixed(2),
            style: AppTextStyles.heading,
          ),
          const SizedBox(height: 10),
          RatingStars(
            value: 3,
            onValueChanged: (v) {},
            starCount: 5,
            starSize: 25,
            starSpacing: 2,
            maxValue: 5,
            valueLabelVisibility: false,
            starOffColor: const Color(0xffe7e8ea),
            starColor: Colors.yellow[700]!,
          ),
          const SizedBox(height: 10),
          Text(
            "based on ${reviews!.length} reviews",
            style: AppTextStyles.headingNormal,
          ),
          const SizedBox(height: 10),
          _buildRatingSummarySection(width, summury),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildRatingSummarySection(double width, List<double> summury) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          _buildRatingSummary("Excellent", summury[5], Colors.green, width),
          _buildRatingSummary("Good", summury[4], Colors.green[300]!, width),
          _buildRatingSummary("Average", summury[3], Colors.yellow, width),
          _buildRatingSummary(
              "Below Average", summury[2], Colors.orange, width),
          _buildRatingSummary("Poor", summury[1], Colors.red, width),
        ],
      ),
    );
  }

  Widget _buildLeaveReview(double width) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Leave a Review",
            style: AppTextStyles.heading,
          ),
          const SizedBox(height: 5),
          RatingStars(
            value: review.rate,
            onValueChanged: (v) {
              setState(() {
                review.rate = v;
              });
            },
            starCount: 5,
            starSize: 25,
            starSpacing: 10,
            maxValue: 5,
            valueLabelVisibility: false,
            starOffColor: const Color(0xffe7e8ea),
            starColor: Colors.yellow[700]!,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.4),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller:
                            TextEditingController(text: review.feedback),
                        maxLines: null,
                        onChanged: (value) {
                          review.feedback = value;
                        },
                        decoration: InputDecoration(
                          // labelText: "Comment",
                          hintText: "Type something...",
                          border:
                              InputBorder.none, // No border when not focused
                          enabledBorder:
                              InputBorder.none, // No border when enabled
                          focusedBorder:
                              InputBorder.none, // No border when focused
                          suffixIcon: IconButton(
                            icon: Icon(Icons.attach_file,
                                color: AppColors.iconColor),
                            onPressed: () {
                              _showUploadPicDialog(context, width);
                            },
                          ),
                        ),
                      ),
                      _imageFile != null
                          ? ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              child: Image.file(
                                _imageFile!,
                                // width: 80,
                                // height: 80,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                    color: AppColors.primary,
                  ),
                  child: IconButton(
                      onPressed: () async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        final String uuidUser =
                            prefs.getString('uuid_user') ?? "";
                        String imgUrl = "";
                        if (_imageFile != null) {
                          imgUrl = await uploadImageService.uploadImageReview(
                              'review', _imageFile!);
                        }
                        review.imgUrl = imgUrl;
                        review.uuidUser = uuidUser;
                        review.uuidRecipe = widget.recipe.uuid;
                        await reviewService.addReview(review);

                        setState(() {
                          _imageFile = null;
                          review = ReviewDto(
                              uuid: "",
                              uuidUser: "",
                              uuidRecipe: "",
                              rate: 5,
                              feedback: '',
                              imgUrl: '',
                              userAvatar: '',
                              userName: '',
                              createdAt: DateTime.now());
                        });
                      },
                      icon: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 30,
                      )))
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRatingSummary(
      String title, double percentage, Color color, double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: width * 0.28,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            height: 10,
            width: width * 0.6,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
              color: Colors.grey[300],
            ),
            child: Row(
              children: [
                Container(
                  height: 10,
                  width: width * 0.6 * percentage,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(double width) {
    return SizedBox(
      height: width * 0.6,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          _buildMainImage(width),
          _buildTitleCard(width),
          _buildInfoCard(width),
        ],
      ),
    );
  }

  Widget _buildMainImage(double width) {
    return Positioned(
      bottom: 40,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: SizedBox(
          width: width * 0.9,
          height: width * 0.5,
          child: CachedNetworkImage(
            imageUrl: widget.recipe.recipeUrl,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: downloadProgress.progress,
                ),
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleCard(double width) {
    return Positioned(
      bottom: 40,
      child: Container(
        height: 60,
        width: width * 0.8,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: AppColors.primary,
        ),
        child: Center(
          child: Text(widget.recipe.titleRecipe,
              textAlign: TextAlign.center, style: AppTextStyles.headingWhite),
        ),
      ),
    );
  }

  Widget _buildInfoCard(double width) {
    return Positioned(
      bottom: 0,
      child: Container(
        height: 40,
        width: width * 0.8,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(AppSizes.borderRadiusPrimary),
            bottomRight: Radius.circular(AppSizes.borderRadiusPrimary),
          ),
          color: AppColors.background,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(0, 4),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfoItem(
                Icons.favorite, Colors.red, "${widget.recipe.numberLikes}"),
            _buildInfoItem(Icons.star_outlined, Colors.yellow.shade600, "4.5"),
            _buildInfoItem(Icons.timer_outlined, Colors.blue,
                _formatTime(widget.recipe.timer)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, Color iconColor, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          icon == Icons.favorite
              ? GestureDetector(
                  onTap: () async {
                    final likedTmp = await likedRecipeService
                        .toggleLikedRecipe(widget.recipe.uuid);
                    setState(() {
                      widget.recipe.isLikedByOwner = likedTmp;
                      if (likedTmp) {
                        widget.recipe.numberLikes++;
                      } else {
                        widget.recipe.numberLikes--;
                      }
                    });
                  },
                  child: Icon(Icons.favorite,
                      color: widget.recipe.isLikedByOwner
                          ? Colors.red
                          : Colors.grey[300],
                      size: AppSizes.iconSize),
                )
              : Icon(icon, color: iconColor, size: AppSizes.iconSize),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20),
      child: Text(
        title,
        style: AppTextStyles.heading,
      ),
    );
  }

  Widget _buildIngredientsList() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.recipe.ingredients.map((ingredient) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(right: 20, top: 5),
            child: ListTile(
              leading: const Icon(
                Icons.add_box_rounded,
                color: AppColors.button,
                size: AppSizes.iconSize,
              ),
              title: Text(
                ingredient,
                style: AppTextStyles.body,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildUserReviewSection(double width, ReviewDto feedback) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  imageUrl: feedback.userAvatar,
                  width: 45,
                  height: 45,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, progress) =>
                      const Center(
                          child: CircularProgressIndicator(strokeWidth: 2)),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(width: AppSizes.spaceBetweenWidget),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feedback.userName,
                    style: AppTextStyles.body,
                  ),
                  Row(
                    children: [
                      RatingStars(
                        value: feedback.rate,
                        onValueChanged: (v) {},
                        starCount: 5,
                        starSize: 18,
                        starSpacing: 2,
                        maxValue: 5,
                        valueLabelVisibility: false,
                        starOffColor: const Color(0xffe7e8ea),
                        starColor: Colors.yellow[700]!,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${feedback.rate}',
                        style: AppTextStyles.body,
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Text(
                timeago.format(feedback.createdAt),
                style: TextStyle(color: Colors.grey[800]),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ExpandableTextWidget(
            text: feedback.feedback,
          ),
          const SizedBox(height: 20),
          feedback.imgUrl != ''
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: feedback.imgUrl,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (context, url, progress) =>
                        const Center(
                            child: CircularProgressIndicator(strokeWidth: 2)),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                )
              : Container(),
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
