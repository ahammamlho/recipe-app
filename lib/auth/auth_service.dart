import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recipe/dto/user_dto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:math';

// ADAKJHFJdksjh35232@

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthResponse?> googleSignIn() async {
    try {
      var iosClientId = dotenv.env['IOS_CLIENT_ID'] as String;

      final GoogleSignIn googleSignIn = GoogleSignIn(clientId: iosClientId);

      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }
      UserDTO userData = UserDTO(
        id: '',
        fullName: googleUser.displayName == null
            ? " "
            : googleUser.displayName as String,
        email: googleUser.email,
        avatarUrl:
            googleUser.photoUrl == null ? "" : googleUser.photoUrl as String,
        socialMediaUrl: '',
        score: 0,
      );
      await addUserIfNotExist(userData);
      return _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e) {
      return null;
    }
  }

  Future<AuthResponse?> appleSignIn() async {
    try {
      final rawNonce = _supabase.auth.generateRawNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      final idToken = credential.identityToken;
      if (idToken == null) {
        throw const AuthException(
            'Could not find ID Token from generated credential.');
      }

      var result = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );
      String familyName = credential.familyName == null ? "" : "";
      String givenName = credential.givenName == null ? "" : "";
      UserDTO userData = UserDTO(
        id: '',
        fullName: "$familyName $givenName",
        email: result.session!.user.email == null
            ? ""
            : result.session!.user.email as String,
        avatarUrl: "",
        socialMediaUrl: '',
        score: 0,
      );
      await addUserIfNotExist(userData);
      print(userData.toJson());
      return result;
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  Future<void> addUserIfNotExist(UserDTO user) async {
    try {
      final existingUser =
          await _supabase.from('user').select().eq('email', user.email);
      if (existingUser.isEmpty) {
        await _supabase.from('user').insert({
          'email': user.email,
          'full_name': user.fullName,
          'avatar_url': user.avatarUrl,
          'user_name': user.fullName.split(' ')[0] == ""
              ? generateRandomUsername()
              : user.fullName.split(' ')[0],
        });
      }
    } catch (error) {
      print(error);
    }
  }

  String generateRandomUsername() {
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final Random random = Random();

    // Generate a string of 5 random characters
    return List.generate(5, (index) => chars[random.nextInt(chars.length)])
        .join();
  }
}
