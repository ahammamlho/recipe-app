import 'package:recipe/dto/user_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<UserDTO?> getCurrentUserData() async {
    final session = _supabase.auth.currentSession;

    if (session == null || session.user == null) {
      print("No active session or user found.");
      return null;
    }

    final String email = session.user.email as String;

    try {
      final response = await _supabase
          .from('user')
          .select()
          .eq('email', email)
          .maybeSingle();

      if (response == null) {
        print("No user data found for email: $email");
        return null;
      }
      return UserDTO.fromJson(response);
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }
}
