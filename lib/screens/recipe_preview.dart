import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:recipe/const/app_styles.dart';
import 'package:recipe/dto/recipce_dto.dart';
import 'package:recipe/widgets/expandable_text.dart';
import 'package:recipe/widgets/time_line_widget.dart';

class RecipePreview extends StatefulWidget {
  final RecipceDto recipe;
  const RecipePreview({super.key, required this.recipe});

  @override
  State<RecipePreview> createState() => _RecipePreviewState();
}

class _RecipePreviewState extends State<RecipePreview> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    List<String> ingredients = [
      "1/4 olive oil",
      "3 cloves",
      "1 red onion, sliced",
      "1 tomato"
    ];
    List<String> directions = [
      "Make the Crust: Combine flour and butter until crumbly. Add water gradually to form dough. Chill for 30 minutes.",
      "Prepare the Tarts: Roll out the dough, cut into circles, and press into a muffin tin to form shells.",
      "Prepare the Filling: Add ingredients into the tart shells.",
      "Bake: Preheat oven to 375°F (190°C) and bake for 20-25 minutes until golden."
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipe Details"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(width),
            _buildSectionTitle("Ingredients"),
            _buildIngredientsList(ingredients),
            _buildSectionTitle("Steps"),
            TimeLineWidget(
              steps: widget.recipe.steps,
              isCheckedList: List.generate(directions.length, (index) => false),
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
            _buildReviewsSection(width),
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
            _buildUserReviewSection(width),
            _buildUserReviewSection(width),
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

  Widget _buildReviewsSection(double width) {
    return Center(
      child: Column(
        children: [
          const Text(
            "4.0",
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
          const Text(
            "based on 23 reviews",
            style: AppTextStyles.headingNormal,
          ),
          const SizedBox(height: 10),
          _buildRatingSummarySection(width),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLeaveReview(double width) {
    late double value = 4;
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
            value: value,
            onValueChanged: (v) {
              setState(() {
                value = v;
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
                child: TextField(
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: "Comment",
                    hintText: "Type something...",
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.borderRadiusPrimary),
                      borderSide:
                          const BorderSide(width: 1), // Border thickness
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: AppColors.border, width: 1),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.attach_file, color: AppColors.iconColor),
                      onPressed: () {},
                    ),
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
                      onPressed: () {},
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

  Widget _buildRatingSummarySection(double width) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          _buildRatingSummary("Excellent", 0.9, Colors.green, width),
          _buildRatingSummary("Good", 0.5, Colors.green[300]!, width),
          _buildRatingSummary("Average", 0.7, Colors.yellow, width),
          _buildRatingSummary("Below Average", 0.3, Colors.orange, width),
          _buildRatingSummary("Poor", 0.1, Colors.red, width),
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
          Icon(icon, color: iconColor, size: AppSizes.iconSize),
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

  Widget _buildIngredientsList(List<String> ingredients) {
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

  Widget _buildUserReviewSection(double width) {
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
                  imageUrl:
                      "https://media.istockphoto.com/id/1352937979/photo/vegetable-storage.jpg?s=2048x2048&w=is&k=20&c=0nk02sPEhDEYwOWLHpELRCmTpbKBCYmQqwEIuLDfTS0=",
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
                  const Text(
                    "Hello word",
                    style: AppTextStyles.body,
                  ),
                  Row(
                    children: [
                      RatingStars(
                        value: 3,
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
                      const Text(
                        "5.0",
                        style: AppTextStyles.body,
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Text(
                "1 day ago",
                style: TextStyle(color: Colors.grey[800]),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const ExpandableTextWidget(
            text:
                "This is a long text example to demonstrate the show more and show less functionality in Flutter. This feature is particularly useful for displaying large blocks of text in a limited space. Tap on 'Show more' to see the full content.",
          ),
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
}
