import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recipe/dto/user_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        uuid: '',
        fullName: googleUser.displayName == null
            ? " "
            : googleUser.displayName as String,
        email: googleUser.email,
        avatarUrl:
            googleUser.photoUrl == null ? "" : googleUser.photoUrl as String,
        socialMediaUrl: '',
        userName: "",
        score: 0,
        bio: "",
        numberFollowers: 0,
        numberRecipes: 0,
        viewsProfile: 0,
        status: "",
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
          uuid: '',
          fullName: "$familyName $givenName",
          email: result.session!.user.email == null
              ? ""
              : result.session!.user.email as String,
          avatarUrl: "",
          userName: "",
          socialMediaUrl: '',
          score: 0,
          bio: "",
          numberFollowers: 0,
          numberRecipes: 0,
          viewsProfile: 0,
          status: "");
      await addUserIfNotExist(userData);
      return result;
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<void> addUserIfNotExist(UserDTO user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final existingUser =
          await _supabase.from('user').select().eq('email', user.email);

      if (existingUser.isEmpty) {
        final resp = await _supabase.from('user').insert({
          'email': user.email,
          'full_name': user.fullName,
          'social_media_link': "",
          'bio': "",
          'avatar_url': user.avatarUrl,
          'user_name': user.fullName.split(' ')[0] == ""
              ? generateRandomUsername()
              : user.fullName.split(' ')[0],
          "number_followers": 0,
          "number_recipes": 0,
          "views_profile": 0,
          "status": "New member",
        }).select();
        await prefs.setString('uuid_user', resp[0]["uuid"]);
      } else {
        await prefs.setString('uuid_user', existingUser[0]["uuid"]);
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
