import 'package:recipe/dto/recipce_dto.dart';
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
}
