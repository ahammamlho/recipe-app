import 'package:recipe/dto/review_dto.dart';
import 'package:recipe/services/liked_recipe_service.dart';
import 'package:recipe/services/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final likedRecipeService = LikedRecipeService();
  final userService = UserService();

  Future<void> addReview(ReviewDto reviewData) async {
    try {
      Map<String, dynamic> reviewDataWithoutUuid =
          Map.from(reviewData.toJson());
      reviewDataWithoutUuid.remove("uuid");
      reviewDataWithoutUuid.remove("user_name");
      reviewDataWithoutUuid.remove("user_avatar");
      await _supabase.from('review').insert(reviewDataWithoutUuid).select();
    } catch (e) {
      print("Exception occurred during recipe insert: $e");
    }
  }

  Future<void> updateReview(ReviewDto reviewData) async {
    print({
      'rate': reviewData.rate,
      'feedback': reviewData.feedback,
      'img_url': reviewData.imgUrl,
      'created_at': reviewData.createdAt.toIso8601String(),
    });
    try {
      await _supabase
          .from('review')
          .update({
            'rate': reviewData.rate,
            'feedback': reviewData.feedback,
            'img_url': reviewData.imgUrl,
            'created_at': reviewData.createdAt.toIso8601String(),
          })
          .eq('uuid', reviewData.uuid)
          .select();
    } catch (e) {
      print("Exception occurred during recipe insert: $e");
    }
  }

  Future<List<ReviewDto>?> getReviewByRecipe(String uuidRecipe) async {
    try {
      final resp =
          await _supabase.from('review').select().eq('uuid_recipe', uuidRecipe);

      List<ReviewDto> reviews =
          resp.map((recipe) => ReviewDto.fromJson(recipe)).toList();

      final List<ReviewDto> result = await Future.wait(
        reviews.map((review) async {
          final user = await userService.getCurrentUserData();
          review.userName = user!.userName;
          review.userAvatar = user.avatarUrl;
          return review;
        }),
      );

      return result;
    } catch (e) {
      print("Exception occurred during recipe insert: $e");
      return null;
    }
  }
}
