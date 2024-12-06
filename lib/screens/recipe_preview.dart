import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:recipe/widgets/custom_bottom_nav_bar.dart';

class RecipePreview extends StatefulWidget {
  const RecipePreview({super.key});

  @override
  State<RecipePreview> createState() => _RecipePreviewState();
}

class _RecipePreviewState extends State<RecipePreview> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    // Ingredients and Directions
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
            _buildSectionTitle("Directions"),
            _buildDirectionsList(directions),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  // Image Section
  Widget _buildImageSection(double width) {
    return Container(
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

  // Ingredients Section
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

  Widget _buildDirectionsList(List<String> directions) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: directions.asMap().entries.map((entry) {
          int index = entry.key; // Index
          String direction = entry.value; // Direction text
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(right: 20, top: 5),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.top,
              leading: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.green,
                child: Text(
                  (index + 1).toString(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                direction,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
