import 'package:recipe/dto/recipce_dto.dart';
import 'package:recipe/services/liked_recipe_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipceService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final likedRecipeService = LikedRecipeService();

  Future<void> addRecipe(RecipceDto recipeData) async {
    try {
      Map<String, dynamic> recipeDataWithoutUuid =
          Map.from(recipeData.toJson());
      recipeDataWithoutUuid.remove("uuid");

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
}
