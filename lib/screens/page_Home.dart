import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:recipe/screens/recipe_preview.dart';
import 'package:recipe/widgets/custom_bottom_nav_bar.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  void _onSearch(String value) {
    setState(() {
      _searchText = value;
    });
  }

  List<int> items = List.generate(10, (index) => index + 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            // Search Bar (Uncomment if needed)
            // CustomSearchBar(
            //   controller: _searchController,
            //   hintText: "Search recipes...",
            //   onSearch: _onSearch,
            // ),
            Expanded(
              child: Card(
                elevation: 8.0,
                child: GridView.builder(
                  padding: const EdgeInsets.all(12.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, // Single column layout
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.15, // Square items
                  ),
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildRecipeCard(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  Widget _buildRecipeCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 8),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                imageUrl:
                    "https://media.istockphoto.com/id/1352937979/photo/vegetable-storage.jpg?s=2048x2048&w=is&k=20&c=0nk02sPEhDEYwOWLHpELRCmTpbKBCYmQqwEIuLDfTS0=",
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, progress) =>
                    const Center(
                        child: CircularProgressIndicator(strokeWidth: 2)),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              "Hello word",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const Icon(Icons.more_horiz),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Expanded(
      child: Container(
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
            _buildImage(context),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                "Hello word",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RecipePreview(),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        child: CachedNetworkImage(
          imageUrl:
              "https://media.istockphoto.com/id/1352937979/photo/vegetable-storage.jpg?s=2048x2048&w=is&k=20&c=0nk02sPEhDEYwOWLHpELRCmTpbKBCYmQqwEIuLDfTS0=",
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, progress) =>
              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.favorite, color: Colors.red, size: 20),
          const SizedBox(width: 5),
          const Text("12", style: TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          RatingStars(
            value: 3,
            onValueChanged: (v) {},
            starCount: 5,
            starSize: 16,
            starSpacing: 2,
            maxValue: 5,
            valueLabelVisibility: false,
            starOffColor: const Color(0xffe7e8ea),
            starColor: Colors.yellow,
          ),
          const SizedBox(width: 5),
          const Text("12 Reviews", style: TextStyle(fontSize: 16)),
          const Spacer(),
          const Icon(Icons.timer_outlined, color: Colors.green, size: 20),
          const SizedBox(width: 5),
          const Text("60min", style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
