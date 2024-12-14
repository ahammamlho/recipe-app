import 'package:recipe/dto/user_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipceService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> addRecipe(UserDTO updateData) async {
    try {
      final response = await _supabase
          .from('user')
          .update(updateData.toJson())
          .eq('uuid', updateData.uuid)
          .select();

      if (response.isEmpty) {
        print("No matching user found to update.");
        return;
      }
    } catch (e) {
      print("Exception occurred during user update: $e");
    }
  }
}
