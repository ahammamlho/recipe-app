import 'package:recipe/dto/liked_recipe_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LikedRecipeService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<bool> toggleLikedRecipe(String uuidRecipe) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String uuidUser = prefs.getString('uuid_user') ?? "";

      final existingLiked = await _supabase
          .from('liked_recipe')
          .select()
          .eq('uuid_user', uuidUser)
          .eq('uuid_recipe', uuidRecipe);
      if (existingLiked.isNotEmpty) {
        await _supabase
            .from('liked_recipe')
            .delete()
            .eq('uuid_user', uuidUser)
            .eq('uuid_recipe', uuidRecipe);
        return false;
      } else {
        await _supabase
            .from('liked_recipe')
            .insert({'uuid_user': uuidUser, 'uuid_recipe': uuidRecipe});
        return true;
      }
    } catch (e) {
      print("Exception occurred during recipe select: $e");
      return false;
    }
  }

  Future<List<int>> getLikedRecipe(String uuidRecipe) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String uuidUser = prefs.getString('uuid_user') ?? "";
      int isLikedByOwner = 0;
      final likes = await _supabase
          .from('liked_recipe')
          .select()
          .eq('uuid_recipe', uuidRecipe);

      for (var like in likes) {
        var likeDto = LikedRecipeDto.fromJson(like);
        if (likeDto.uuidUser == uuidUser) {
          isLikedByOwner = 1;
        }
      }
      return [likes.length, isLikedByOwner];
    } catch (e) {
      print("Exception occurred during recipe select: $e");
      return [0, 0];
    }
  }
}
