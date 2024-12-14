import 'package:recipe/dto/recipce_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipceService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> addRecipe(RecipceDto recipeData) async {
    try {
      Map<String, dynamic> recipeDataWithoutUuid =
          Map.from(recipeData.toJson());
      recipeDataWithoutUuid.remove("uuid");

      final resp =
          await _supabase.from('recipe').insert(recipeDataWithoutUuid).select();
      print(resp);
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
      print(resp);
      List<RecipceDto> recipces =
          resp.map((recipe) => RecipceDto.fromJson(recipe)).toList();

      return recipces;
    } catch (e) {
      print("Exception occurred during recipe select: $e");
      return null;
    }
  }
}
