import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadImageService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<String?> uploadAvatar(String bucket, File file, String uuid) async {
    final fileName = 'images/$uuid.jpg';

    try {
      await supabase.storage.from(bucket).remove([fileName]);

      await supabase.storage.from(bucket).upload(fileName, file);

      final imageUrl = supabase.storage.from(bucket).getPublicUrl(fileName);

      return imageUrl;
    } catch (e) {
      print("Error uploading image: $e");
    }
    return null;
  }
}
