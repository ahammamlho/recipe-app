import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:recipe/widgets/custom_bottom_nav_bar.dart';
import 'package:recipe/widgets/time_line_widget.dart';

class RecipePreview extends StatefulWidget {
  const RecipePreview({super.key});

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
              steps: directions,
              isCheckedList: List.generate(directions.length, (index) => false),
            ),
            _buildSectionTitle("Reviews"),
            Center(
              child: Column(
                children: [
                  const Text(
                    "4.0",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  _buildRatingSummarySection(width),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
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
            imageUrl:
                "https://media.istockphoto.com/id/1352937979/photo/vegetable-storage.jpg?s=2048x2048&w=is&k=20&c=0nk02sPEhDEYwOWLHpELRCmTpbKBCYmQqwEIuLDfTS0=",
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
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: Colors.blueAccent.shade700,
        ),
        child: const Center(
          child: Text(
            "Delicious Tart Recipe",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
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
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          color: Colors.white,
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
            _buildInfoItem(Icons.favorite, Colors.red, "12"),
            _buildInfoItem(Icons.star_outlined, Colors.yellow.shade600, "4.5"),
            _buildInfoItem(Icons.timer_outlined, Colors.blue, "45min"),
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
          Icon(icon, color: iconColor, size: 20),
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
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildIngredientsList(List<String> ingredients) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: ingredients.map((ingredient) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(right: 20, top: 5),
            child: ListTile(
              leading: const Icon(
                Icons.add_box_rounded,
                color: Colors.green,
                size: 30,
              ),
              title: Text(
                ingredient,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
