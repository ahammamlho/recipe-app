import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:recipe/auth/auth_service.dart';
import 'package:recipe/const/app_styles.dart';
import 'package:recipe/widgets/search_bar.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  final authService = AuthService();
  final TextEditingController _searchController = TextEditingController();
  // String _searchText = "";

  void _onSearch(String value) {
    setState(() {
      // _searchText = value;
    });
  }

  List<int> items = List.generate(10, (index) => index + 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                authService.signOut();
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.red,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: _buildHelloUser()),
            const SizedBox(height: AppSizes.spaceBetweenWidget),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: const Row(
                children: [
                  Text(
                    'What would you like to cook today?',
                    style: AppTextStyles.heading,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            CustomSearchBar(
              controller: _searchController,
              hintText: "Search recipes",
              onSearch: _onSearch,
            ),
            const SizedBox(height: AppSizes.spaceBetweenWidget),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.14,
              ),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildRecipeCard(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 8),
        _buildContent(context),
      ],
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
              style: AppTextStyles.body,
            ),
          ],
        ),
        const Icon(
          Icons.more_horiz,
          size: AppSizes.iconSize,
        ),
      ],
    );
  }

  Widget _buildHelloUser() {
    return Row(
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
                const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          "Hello, Ali",
          style: AppTextStyles.heading2,
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
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
          _buildImage(context),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              "Hello word",
              style: AppTextStyles.heading2,
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.to(const RecipePreview());
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
          const Icon(Icons.favorite,
              color: Colors.red, size: AppSizes.iconSize),
          const SizedBox(width: 5),
          const Text("12", style: AppTextStyles.body),
          const SizedBox(width: 10),
          RatingStars(
            value: 3,
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
          const Text("12 Reviews", style: AppTextStyles.body),
          const Spacer(),
          const Icon(Icons.timer_outlined,
              color: Colors.green, size: AppSizes.iconSize),
          const SizedBox(width: 5),
          const Text("60min", style: AppTextStyles.body),
        ],
      ),
    );
  }
}
