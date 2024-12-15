import 'package:recipe/dto/recipce_dto.dart';
import 'package:recipe/dto/review_dto.dart';
import 'package:recipe/services/liked_recipe_service.dart';
import 'package:recipe/services/review_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipceService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final likedRecipeService = LikedRecipeService();
  final reviewService = ReviewService();

  Future<void> addRecipe(RecipceDto recipeData) async {
    try {
      Map<String, dynamic> recipeDataWithoutUuid =
          Map.from(recipeData.toJson());
      recipeDataWithoutUuid.remove("uuid");
      recipeDataWithoutUuid.remove("rate_reviews");
      recipeDataWithoutUuid.remove("number_reviews");

      final resp =
          await _supabase.from('recipe').insert(recipeDataWithoutUuid).select();
    } catch (e) {
      print("Exception occurred during recipe insert: $e");
    }
  }

  Future<List<RecipceDto>?> getMyRecipe() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String uuidUser = prefs.getString('uuid_user') ?? "";
      final resp =
          await _supabase.from('recipe').select().eq("uuid_user", uuidUser);
      List<RecipceDto> recipces =
          resp.map((recipe) => RecipceDto.fromJson(recipe)).toList();

      final List<RecipceDto> result = await Future.wait(
        recipces.map((recipe) async {
          final like = await likedRecipeService.getLikedRecipe(recipe.uuid);
          final reviews = await reviewService.getReviewByRecipe(recipe.uuid);
          recipe.numberReviews = reviews!.length | 0;
          recipe.rateReviews = calculateRatingSummary(reviews);
          recipe.isLikedByOwner = like[1] == 1;
          recipe.numberLikes = like[0];
          return recipe;
        }),
      );

      return result;
    } catch (e) {
      print("Exception occurred during recipe select: $e");
      return null;
    }
  }

  double calculateRatingSummary(List<ReviewDto>? reviews) {
    if (reviews == null || reviews.isEmpty) {
      return 0;
    }
    double totalRating = 0.0;
    int count = reviews.length;

    for (var review in reviews) {
      totalRating += review.rate;
    }
    double averageRating = totalRating / count;
    return averageRating;
  }
}
